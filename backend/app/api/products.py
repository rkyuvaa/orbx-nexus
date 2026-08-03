from datetime import date

from fastapi import APIRouter, HTTPException, Query
from sqlalchemy import select, text
from pydantic import BaseModel, ConfigDict
from typing import Optional

from app.api.deps import CurrentUser, DBSession
from app.models.master import Product, Process, Rate, UnitOfMeasure, StockItem

router = APIRouter()


def _s(fy: str) -> str:
    return f"fy_{fy}"


# ──── Schemas ────

class UoMOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    name: str
    symbol: str


class UoMCreate(BaseModel):
    name: str
    symbol: str


class ProductOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    name: str
    product_code: str | None = None
    description: str | None = None
    uom_id: int | None = None
    weight: float | None = 0.0
    is_active: bool


class ProductCreate(BaseModel):
    name: str
    product_code: str | None = None
    description: str | None = None
    uom_id: int | None = None
    weight: float | None = 0.0


class ProcessOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    name: str
    process_code: str | None = None
    product_id: int | None = None
    sequence: int
    description: str | None = None
    is_active: bool
    company_rate: float
    contractor_rate: float
    gst_percent: float = 0.0


class ProcessCreate(BaseModel):
    name: str
    process_code: str | None = None
    product_id: int | None = None
    sequence: int = 0
    description: str | None = None
    company_rate: float = 0.0
    contractor_rate: float = 0.0
    gst_percent: float = 0.0



class RateOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    process_id: int
    ledger_id: int | None = None
    product_id: int | None = None
    rate: float
    uom_id: int | None = None
    effective_from: str | None = None
    effective_to: str | None = None
    is_active: bool


class RateCreate(BaseModel):
    process_id: int
    ledger_id: int | None = None
    product_id: int | None = None
    rate: float
    uom_id: int | None = None
    effective_from: str | None = None
    effective_to: str | None = None


class StockItemOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    name: str
    item_code: str | None = None
    uom_id: int | None = None
    opening_stock: float
    reorder_level: float
    is_active: bool


class StockItemCreate(BaseModel):
    name: str
    item_code: str | None = None
    uom_id: int | None = None
    opening_stock: float = 0
    reorder_level: float = 0


# ──── UoM ────

@router.get("/uom", response_model=list[UoMOut])
async def list_uom(current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(UnitOfMeasure).order_by(UnitOfMeasure.name))
    return result.scalars().all()


@router.post("/uom", response_model=UoMOut, status_code=201)
async def create_uom(body: UoMCreate, current_user: CurrentUser, db: DBSession):
    uom = UnitOfMeasure(**body.model_dump())
    db.add(uom)
    await db.flush()
    await db.refresh(uom)
    return uom


@router.put("/uom/{uom_id}", response_model=UoMOut)
async def update_uom(uom_id: int, body: UoMCreate, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(UnitOfMeasure).where(UnitOfMeasure.id == uom_id))
    uom = result.scalar_one_or_none()
    if not uom:
        raise HTTPException(status_code=404)
    uom.name = body.name
    uom.symbol = body.symbol
    await db.flush()
    await db.refresh(uom)
    return uom


@router.delete("/uom/{uom_id}", status_code=204)
async def delete_uom(uom_id: int, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(UnitOfMeasure).where(UnitOfMeasure.id == uom_id))
    uom = result.scalar_one_or_none()
    if not uom:
        raise HTTPException(status_code=404)
    await db.delete(uom)


# ──── Stock Items ────

@router.get("/stock-items", response_model=list[StockItemOut])
async def list_stock_items(current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(StockItem).order_by(StockItem.name))
    return result.scalars().all()


@router.post("/stock-items", response_model=StockItemOut, status_code=201)
async def create_stock_item(body: StockItemCreate, current_user: CurrentUser, db: DBSession):
    item = StockItem(**body.model_dump())
    db.add(item)
    await db.flush()
    await db.refresh(item)
    return item


@router.put("/stock-items/{item_id}", response_model=StockItemOut)
async def update_stock_item(item_id: int, body: StockItemCreate, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(StockItem).where(StockItem.id == item_id))
    item = result.scalar_one_or_none()
    if not item:
        raise HTTPException(status_code=404)
    for k, v in body.model_dump().items():
        setattr(item, k, v)
    await db.flush()
    await db.refresh(item)
    return item


@router.delete("/stock-items/{item_id}", status_code=204)
async def delete_stock_item(item_id: int, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(StockItem).where(StockItem.id == item_id))
    item = result.scalar_one_or_none()
    if not item:
        raise HTTPException(status_code=404)
    await db.delete(item)


# ──── Products ────

@router.get("/", response_model=list[ProductOut])
async def list_products(current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Product).order_by(Product.name))
    return result.scalars().all()


@router.get("/stock-balance")
async def product_stock_balance(
    current_user: CurrentUser, db: DBSession,
    fy: str = Query(default="2026_2027"),
    as_of_date: Optional[str] = Query(None),
):
    schema = _s(fy)
    aod = as_of_date or date.today().isoformat()
    result = await db.execute(
        text(f"""
            WITH inward_totals AS (
              SELECT product_id, SUM(qty) AS inward_qty FROM (
                SELECT product_id, quantity AS qty
                FROM {schema}.stock_inward
                WHERE inward_date <= :aod AND product_id IS NOT NULL
                  AND jsonb_array_length(COALESCE(items, '[]'::jsonb)) = 0
                UNION ALL
                SELECT (item->>'product_id')::int,
                  (item->>'quantity')::numeric
                FROM {schema}.stock_inward,
                  jsonb_array_elements(COALESCE(items, '[]'::jsonb)) AS item
                WHERE inward_date <= :aod
                  AND jsonb_array_length(COALESCE(items, '[]'::jsonb)) > 0
              ) sub GROUP BY product_id
            ), outward_totals AS (
              SELECT product_id, SUM(qty) AS outward_qty FROM (
                SELECT product_id, quantity AS qty
                FROM {schema}.stock_outward
                WHERE outward_date <= :aod AND product_id IS NOT NULL
                  AND jsonb_array_length(COALESCE(items, '[]'::jsonb)) = 0
                UNION ALL
                SELECT (item->>'product_id')::int,
                  (item->>'quantity')::numeric
                FROM {schema}.stock_outward,
                  jsonb_array_elements(COALESCE(items, '[]'::jsonb)) AS item
                WHERE outward_date <= :aod
                  AND jsonb_array_length(COALESCE(items, '[]'::jsonb)) > 0
              ) sub GROUP BY product_id
            ), adj_totals AS (
              SELECT product_id, SUM(quantity) AS adj_qty
              FROM {schema}.stock_adjustments
              WHERE adjustment_date <= :aod GROUP BY product_id
            )
            SELECT
              p.id, p.name,
              COALESCE(p.product_code, '-') AS product_code,
              COALESCE(u.symbol, '-') AS uom_symbol,
              COALESCE(it.inward_qty, 0) AS inward_qty,
              COALESCE(ot.outward_qty, 0) AS outward_qty,
              COALESCE(at.adj_qty, 0) AS adjustment_qty,
              COALESCE(it.inward_qty, 0)
                - COALESCE(ot.outward_qty, 0)
                + COALESCE(at.adj_qty, 0) AS balance_qty
            FROM master.products p
            LEFT JOIN master.units_of_measure u ON u.id = p.uom_id
            LEFT JOIN inward_totals it ON it.product_id = p.id
            LEFT JOIN outward_totals ot ON ot.product_id = p.id
            LEFT JOIN adj_totals at ON at.product_id = p.id
            WHERE p.is_active = TRUE
            ORDER BY p.name
        """),
        {"aod": aod}
    )
    return [dict(r) for r in result.mappings().all()]


@router.get("/{product_id}", response_model=ProductOut)
async def get_product(product_id: int, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Product).where(Product.id == product_id))
    p = result.scalar_one_or_none()
    if not p:
        raise HTTPException(status_code=404)
    return p


@router.post("/", response_model=ProductOut, status_code=201)
async def create_product(body: ProductCreate, current_user: CurrentUser, db: DBSession):
    p = Product(**body.model_dump())
    db.add(p)
    await db.flush()
    await db.refresh(p)
    return p


@router.put("/{product_id}", response_model=ProductOut)
async def update_product(product_id: int, body: ProductCreate, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Product).where(Product.id == product_id))
    p = result.scalar_one_or_none()
    if not p:
        raise HTTPException(status_code=404)
    for k, v in body.model_dump().items():
        setattr(p, k, v)
    await db.flush()
    await db.refresh(p)
    return p


@router.delete("/{product_id}", status_code=204)
async def delete_product(product_id: int, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Product).where(Product.id == product_id))
    p = result.scalar_one_or_none()
    if not p:
        raise HTTPException(status_code=404)
    await db.delete(p)


# ──── Processes ────

@router.get("/processes/all", response_model=list[ProcessOut])
async def list_processes(
    current_user: CurrentUser, db: DBSession, product_id: Optional[int] = Query(None)
):
    q = select(Process)
    if product_id:
        q = q.where(Process.product_id == product_id)
    result = await db.execute(q.order_by(Process.sequence, Process.name))
    return result.scalars().all()


@router.post("/processes", response_model=ProcessOut, status_code=201)
async def create_process(body: ProcessCreate, current_user: CurrentUser, db: DBSession):
    p = Process(**body.model_dump())
    db.add(p)
    await db.flush()
    await db.refresh(p)
    return p


@router.put("/processes/{process_id}", response_model=ProcessOut)
async def update_process(process_id: int, body: ProcessCreate, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Process).where(Process.id == process_id))
    p = result.scalar_one_or_none()
    if not p:
        raise HTTPException(status_code=404)
    for k, v in body.model_dump().items():
        setattr(p, k, v)
    await db.flush()
    await db.refresh(p)
    return p


@router.delete("/processes/{process_id}", status_code=204)
async def delete_process(process_id: int, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Process).where(Process.id == process_id))
    p = result.scalar_one_or_none()
    if not p:
        raise HTTPException(status_code=404)
    await db.delete(p)


# ──── Rates ────

@router.get("/rates/all", response_model=list[RateOut])
async def list_rates(
    current_user: CurrentUser, db: DBSession, process_id: Optional[int] = Query(None), product_id: Optional[int] = Query(None)
):
    q = select(Rate)
    if process_id:
        q = q.where(Rate.process_id == process_id)
    if product_id:
        q = q.where(Rate.product_id == product_id)
    result = await db.execute(q)
    return result.scalars().all()


@router.post("/rates", response_model=RateOut, status_code=201)
async def create_rate(body: RateCreate, current_user: CurrentUser, db: DBSession):
    r = Rate(**body.model_dump())
    db.add(r)
    await db.flush()
    await db.refresh(r)
    return r


@router.put("/rates/{rate_id}", response_model=RateOut)
async def update_rate(rate_id: int, body: RateCreate, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Rate).where(Rate.id == rate_id))
    r = result.scalar_one_or_none()
    if not r:
        raise HTTPException(status_code=404)
    for k, v in body.model_dump().items():
        setattr(r, k, v)
    await db.flush()
    await db.refresh(r)
    return r


@router.delete("/rates/{rate_id}", status_code=204)
async def delete_rate(rate_id: int, current_user: CurrentUser, db: DBSession):
    result = await db.execute(select(Rate).where(Rate.id == rate_id))
    r = result.scalar_one_or_none()
    if not r:
        raise HTTPException(status_code=404)
    await db.delete(r)
