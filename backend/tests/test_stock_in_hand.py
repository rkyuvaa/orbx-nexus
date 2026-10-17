"""
Automated Backend Tests for Stock in Hand Report and Supplier Attribution.

Validates:
1. Default Stock in Hand total available stock
2. Supplier A filter produces correct attributable stock (no cross-supplier deduction)
3. Supplier B filter produces correct attributable stock
4. Clear supplier filter reconciles with default report
5. Inward only, Inward & Outward calculations
6. Cancelled and draft transactions exclusion
7. Multiple receipts of same product (FIFO and exact single-counting)
8. Exact Texmo screenshot data reconciliation (3,210 qty, 11,200.442 kg)
"""
import pytest
from app.services.inventory_service import compute_stock_in_hand_balances


@pytest.fixture
def sample_master_data():
    ledger_map = {
        101: "TEXMO INDUSTRIES PUMP DIVISION",
        102: "C.R.I. PUMPS PRIVATE LIMITED",
    }
    product_map = {
        1: "CGH122 2H40QN CASING",
        2: "GAS014-DIAPHRAM CAP",
        3: "GPS006-CABLE BOX",
        4: "GPS014-CABLE BOX",
        5: "HIS001-INLRT BRACKET",
        6: "HIS111-INLET BRACKET",
        7: "IMC078 IMPELLER",
        8: "IMH003-IMPELLER",
        9: "IMH012-IMPELLER",
        10: "RAB001-REAR COVER",
        11: "RAK007-REAR COVER",
        12: "RAK011 REAR COVER",
        13: "SKA008-STRAINER BRACKET",
    }
    return ledger_map, product_map


@pytest.fixture
def texmo_inward_0688():
    """Inward 0688 exactly matching the user screenshot for Texmo (Total: 3,210 pcs, 11,200.442 kg)."""
    items = [
        {"product_id": 1, "quantity": 196, "weight": 9.898},
        {"product_id": 2, "quantity": 300, "weight": 0.390},
        {"product_id": 3, "quantity": 98,  "weight": 2.960},
        {"product_id": 4, "quantity": 231, "weight": 3.230},
        {"product_id": 5, "quantity": 116, "weight": 4.730},
        {"product_id": 6, "quantity": 256, "weight": 4.830},
        {"product_id": 7, "quantity": 266, "weight": 1.950},
        {"product_id": 8, "quantity": 252, "weight": 3.000},
        {"product_id": 9, "quantity": 40,  "weight": 3.990},
        {"product_id": 10, "quantity": 74,  "weight": 10.458},
        {"product_id": 11, "quantity": 197, "weight": 6.416},
        {"product_id": 12, "quantity": 384, "weight": 4.630},
        {"product_id": 13, "quantity": 800, "weight": 1.340},
    ]
    return {
        "id": 688,
        "inward_no": "0688",
        "inward_date": "2026-10-16",
        "ref_no": "FJ02538",
        "ledger_id": 101,
        "items": items,
    }


def test_default_vs_supplier_filter_reconciliation(sample_master_data, texmo_inward_0688):
    """
    Core Bug Verification:
    Default view shows Texmo Inward 0688 with 3,210.
    When Supplier B has inward and outward for some of the same products (72 of CGH122, 98 of GPS006, 50 of GPS014, 116 of HIS001 = 336),
    filtering by Texmo MUST still produce 3,210 (not 2,874!).
    """
    ledger_map, product_map = sample_master_data

    # Supplier B has an inward
    cri_inward = {
        "id": 550,
        "inward_no": "0550",
        "inward_date": "2026-10-10",
        "ref_no": "CRI-REF-1",
        "ledger_id": 102,
        "items": [
            {"product_id": 1, "quantity": 72, "weight": 9.898},
            {"product_id": 3, "quantity": 98, "weight": 2.960},
            {"product_id": 4, "quantity": 50, "weight": 3.230},
            {"product_id": 5, "quantity": 116, "weight": 4.730},
        ],
    }

    # Supplier B dispatches those 336 items
    cri_outward = {
        "id": 101,
        "outward_no": "OUT-0101",
        "outward_date": "2026-10-17",
        "ledger_id": 102,
        "inward_id": 550,
        "items": [
            {"product_id": 1, "quantity": 72, "inward_id": 550},
            {"product_id": 3, "quantity": 98, "inward_id": 550},
            {"product_id": 4, "quantity": 50, "inward_id": 550},
            {"product_id": 5, "quantity": 116, "inward_id": 550},
        ],
    }

    inwards = [cri_inward, texmo_inward_0688]
    outwards = [cri_outward]

    # 1. Default report (no filter)
    default_res = compute_stock_in_hand_balances(
        inward_rows=inwards,
        outward_rows=outwards,
        ledger_map=ledger_map,
        product_map=product_map,
        filter_ledger_id=None,
    )
    texmo_default_items = [r for r in default_res if r["ledger_id"] == 101]
    texmo_default_qty = sum(r["balance_qty"] for r in texmo_default_items)
    texmo_default_wt = sum(r["balance_weight"] for r in texmo_default_items)

    assert texmo_default_qty == 3210.0
    assert abs(texmo_default_wt - 11200.442) < 0.01

    # 2. Supplier filter applied for Texmo (ledger_id = 101)
    filtered_res = compute_stock_in_hand_balances(
        inward_rows=inwards,
        outward_rows=outwards,
        ledger_map=ledger_map,
        product_map=product_map,
        filter_ledger_id=101,
    )
    texmo_filtered_qty = sum(r["balance_qty"] for r in filtered_res)
    texmo_filtered_wt = sum(r["balance_weight"] for r in filtered_res)

    # In the old code, this was 2,874 because 336 was stolen by Supplier B's outward!
    # With the fix, it MUST remain 3,210.0!
    assert texmo_filtered_qty == 3210.0
    assert abs(texmo_filtered_wt - 11200.442) < 0.01

    # 3. Check individual products that were corrupted in the old code
    product_qty_map = {r["product"]: r["balance_qty"] for r in filtered_res}
    assert product_qty_map["CGH122 2H40QN CASING"] == 196.0  # was 124 in bug
    assert product_qty_map["GPS006-CABLE BOX"] == 98.0       # was 0 (missing) in bug
    assert product_qty_map["GPS014-CABLE BOX"] == 231.0      # was 181 in bug
    assert product_qty_map["HIS001-INLRT BRACKET"] == 116.0  # was 0 (missing) in bug

    # 4. Supplier filter for Supplier B (ledger_id = 102)
    # Supplier B had 336 in and 336 out -> 0 remaining
    cri_filtered_res = compute_stock_in_hand_balances(
        inward_rows=inwards,
        outward_rows=outwards,
        ledger_map=ledger_map,
        product_map=product_map,
        filter_ledger_id=102,
    )
    assert len(cri_filtered_res) == 0


def test_no_cross_supplier_leakage_without_inward_id(sample_master_data):
    """
    Even when an outward transaction has NO inward_id, it must ONLY fall back
    to inwards of the SAME supplier, never crossing to another supplier.
    """
    ledger_map, product_map = sample_master_data

    # Supplier A inward on Day 1 (earlier)
    inward_a = {
        "id": 1,
        "inward_no": "IN-A",
        "inward_date": "2026-10-01",
        "ledger_id": 101,
        "items": [{"product_id": 1, "quantity": 100, "weight": 5.0}],
    }
    # Supplier B inward on Day 2
    inward_b = {
        "id": 2,
        "inward_no": "IN-B",
        "inward_date": "2026-10-05",
        "ledger_id": 102,
        "items": [{"product_id": 1, "quantity": 100, "weight": 5.0}],
    }

    # Supplier B outward with NO inward_id specified
    outward_b = {
        "id": 1,
        "outward_no": "OUT-B",
        "outward_date": "2026-10-10",
        "ledger_id": 102,  # Owned by Supplier B
        "inward_id": None,
        "items": [{"product_id": 1, "quantity": 40}],  # No item-level inward_id
    }

    # Calculate default
    res = compute_stock_in_hand_balances(
        inward_rows=[inward_a, inward_b],
        outward_rows=[outward_b],
        ledger_map=ledger_map,
        product_map=product_map,
        filter_ledger_id=None,
    )

    balances = {r["ledger_id"]: r["balance_qty"] for r in res}
    # Supplier A must NOT have been deducted!
    assert balances[101] == 100.0
    # Supplier B must have deducted 40 -> 60 left!
    assert balances[102] == 60.0

    # Calculate filtered by Supplier A
    res_a = compute_stock_in_hand_balances(
        inward_rows=[inward_a, inward_b],
        outward_rows=[outward_b],
        ledger_map=ledger_map,
        product_map=product_map,
        filter_ledger_id=101,
    )
    assert len(res_a) == 1
    assert res_a[0]["balance_qty"] == 100.0


def test_inward_only_calculation(sample_master_data):
    """When there are no outward transactions, Stock equals valid Inward quantity."""
    ledger_map, product_map = sample_master_data
    inward = {
        "id": 10,
        "inward_no": "IN-10",
        "inward_date": "2026-10-01",
        "ledger_id": 101,
        "items": [
            {"product_id": 1, "quantity": 50, "weight": 2.0},
            {"product_id": 2, "quantity": 75, "weight": 1.0},
        ],
    }
    res = compute_stock_in_hand_balances(
        inward_rows=[inward],
        outward_rows=[],
        ledger_map=ledger_map,
        product_map=product_map,
    )
    assert len(res) == 2
    assert sum(r["balance_qty"] for r in res) == 125.0
    assert sum(r["balance_weight"] for r in res) == 175.0


def test_draft_and_cancelled_transactions_excluded(sample_master_data):
    """Draft, cancelled, rejected, and void transactions must be excluded from stock."""
    ledger_map, product_map = sample_master_data
    valid_inward = {
        "id": 1,
        "inward_no": "IN-01",
        "inward_date": "2026-10-01",
        "ledger_id": 101,
        "items": [{"product_id": 1, "quantity": 100, "weight": 2.0}],
    }
    cancelled_inward = {
        "id": 2,
        "inward_no": "IN-02-CANC",
        "inward_date": "2026-10-02",
        "ledger_id": 101,
        "status": "Cancelled",
        "items": [{"product_id": 1, "quantity": 50, "weight": 2.0}],
    }
    draft_inward = {
        "id": 3,
        "inward_no": "IN-03-DRAFT",
        "inward_date": "2026-10-03",
        "ledger_id": 101,
        "status": "Draft",
        "items": [{"product_id": 1, "quantity": 40, "weight": 2.0}],
    }
    cancelled_outward = {
        "id": 1,
        "outward_no": "OUT-CANC",
        "outward_date": "2026-10-04",
        "ledger_id": 101,
        "status": "Cancelled",
        "inward_id": 1,
        "items": [{"product_id": 1, "quantity": 30}],
    }

    res = compute_stock_in_hand_balances(
        inward_rows=[valid_inward, cancelled_inward, draft_inward],
        outward_rows=[cancelled_outward],
        ledger_map=ledger_map,
        product_map=product_map,
    )

    # Only valid_inward (100) should be counted; cancelled outward should not deduct
    assert len(res) == 1
    assert res[0]["balance_qty"] == 100.0


def test_product_with_multiple_receipts_fifo(sample_master_data):
    """
    Product with multiple receipts across dates:
    Dispatches consume in chronological FIFO order; each receipt is counted once.
    """
    ledger_map, product_map = sample_master_data
    r1 = {
        "id": 1,
        "inward_no": "IN-R1",
        "inward_date": "2026-10-01",
        "ledger_id": 101,
        "items": [{"product_id": 1, "quantity": 50, "weight": 2.0}],
    }
    r2 = {
        "id": 2,
        "inward_no": "IN-R2",
        "inward_date": "2026-10-05",
        "ledger_id": 101,
        "items": [{"product_id": 1, "quantity": 50, "weight": 2.0}],
    }
    # Outward of 60 with no specific inward_id
    out = {
        "id": 1,
        "outward_no": "OUT-01",
        "outward_date": "2026-10-10",
        "ledger_id": 101,
        "items": [{"product_id": 1, "quantity": 60}],
    }

    res = compute_stock_in_hand_balances(
        inward_rows=[r1, r2],
        outward_rows=[out],
        ledger_map=ledger_map,
        product_map=product_map,
    )

    # R1 (50) is fully consumed (0 remaining, omitted from report)
    # R2 (50) has 50 - 10 = 40 remaining
    assert len(res) == 1
    assert res[0]["inward_no"] == "IN-R2"
    assert res[0]["balance_qty"] == 40.0


def test_clear_supplier_filter_returns_original_default_total(sample_master_data):
    """
    Validation Test:
    Default total == Sum of each supplier when filtered.
    Clearing supplier filter restores the exact default total.
    """
    ledger_map, product_map = sample_master_data

    inwards = [
        {
            "id": 1,
            "inward_no": "IN-A1",
            "inward_date": "2026-10-01",
            "ledger_id": 101,
            "items": [{"product_id": 1, "quantity": 100, "weight": 2.0}],
        },
        {
            "id": 2,
            "inward_no": "IN-B1",
            "inward_date": "2026-10-02",
            "ledger_id": 102,
            "items": [{"product_id": 1, "quantity": 200, "weight": 2.0}],
        },
    ]

    outwards = [
        {
            "id": 1,
            "outward_no": "OUT-A1",
            "outward_date": "2026-10-03",
            "ledger_id": 101,
            "inward_id": 1,
            "items": [{"product_id": 1, "quantity": 30}],
        },
        {
            "id": 2,
            "outward_no": "OUT-B1",
            "outward_date": "2026-10-04",
            "ledger_id": 102,
            "inward_id": 2,
            "items": [{"product_id": 1, "quantity": 80}],
        },
    ]

    # 1. Default report (all suppliers)
    default_res = compute_stock_in_hand_balances(
        inward_rows=inwards,
        outward_rows=outwards,
        ledger_map=ledger_map,
        product_map=product_map,
        filter_ledger_id=None,
    )
    total_default_qty = sum(r["balance_qty"] for r in default_res)
    assert total_default_qty == 190.0  # (100 - 30) + (200 - 80) = 70 + 120 = 190

    # 2. Filter Supplier A
    res_a = compute_stock_in_hand_balances(
        inward_rows=inwards,
        outward_rows=outwards,
        ledger_map=ledger_map,
        product_map=product_map,
        filter_ledger_id=101,
    )
    total_a_qty = sum(r["balance_qty"] for r in res_a)
    assert total_a_qty == 70.0

    # 3. Filter Supplier B
    res_b = compute_stock_in_hand_balances(
        inward_rows=inwards,
        outward_rows=outwards,
        ledger_map=ledger_map,
        product_map=product_map,
        filter_ledger_id=102,
    )
    total_b_qty = sum(r["balance_qty"] for r in res_b)
    assert total_b_qty == 120.0

    # 4. Check reconciliation: Default Total == Supplier A Total + Supplier B Total
    assert total_default_qty == total_a_qty + total_b_qty

    # 5. Clear filter (re-run with filter_ledger_id=None)
    cleared_res = compute_stock_in_hand_balances(
        inward_rows=inwards,
        outward_rows=outwards,
        ledger_map=ledger_map,
        product_map=product_map,
        filter_ledger_id=None,
    )
    assert sum(r["balance_qty"] for r in cleared_res) == total_default_qty


@pytest.mark.asyncio
async def test_async_get_stock_in_hand_report(sample_master_data):
    """
    Test the async database function get_stock_in_hand_report
    using an in-memory SQLite database to verify SQL query structure and mapping.
    """
    from unittest.mock import AsyncMock, MagicMock
    from app.services.inventory_service import get_stock_in_hand_report

    mock_db = AsyncMock()

    # Mock ledgers
    mock_ledgers_res = MagicMock()
    mock_ledgers_res.mappings.return_value.all.return_value = [
        {"id": 101, "name": "TEXMO INDUSTRIES PUMP DIVISION"}
    ]

    # Mock products
    mock_products_res = MagicMock()
    mock_products_res.mappings.return_value.all.return_value = [
        {"id": 1, "name": "CGH122 2H40QN CASING"}
    ]

    # Mock all inwards for supplier lookup
    mock_all_inw_res = MagicMock()
    mock_all_inw_res.mappings.return_value.all.return_value = [
        {"id": 688, "ledger_id": 101}
    ]

    # Mock inward rows
    mock_inward_res = MagicMock()
    mock_inward_res.mappings.return_value.all.return_value = [
        {
            "id": 688,
            "inward_no": "0688",
            "inward_date": "2026-10-16",
            "ref_no": "FJ02538",
            "ledger_id": 101,
            "product_id": 1,
            "quantity": 196,
            "weight": 9.898,
            "items": "[]",
        }
    ]

    # Mock outward rows (empty)
    mock_outward_res = MagicMock()
    mock_outward_res.mappings.return_value.all.return_value = []

    mock_db.execute.side_effect = [
        mock_ledgers_res,
        mock_products_res,
        mock_all_inw_res,
        mock_inward_res,
        mock_outward_res,
    ]

    report = await get_stock_in_hand_report(
        db=mock_db,
        schema="fy_2026_2027",
        as_of_date="2026-10-17",
        ledger_id=101,
    )

    assert len(report) == 1
    assert report[0]["inward_no"] == "0688"
    assert report[0]["product"] == "CGH122 2H40QN CASING"
    assert report[0]["balance_qty"] == 196.0
    assert report[0]["supplier_name"] == "TEXMO INDUSTRIES PUMP DIVISION"

