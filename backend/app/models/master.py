"""
Master schema SQLAlchemy models.
All shared/reference data that spans financial years.
"""
from datetime import datetime
from sqlalchemy import (
    Integer, String, Boolean, DateTime, Numeric, Text, ForeignKey, JSON
)
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.sql import func

from app.db.base_class import Base


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    username: Mapped[str] = mapped_column(String(100), unique=True, nullable=False, index=True)
    hashed_password: Mapped[str] = mapped_column(String(255), nullable=False)
    full_name: Mapped[str | None] = mapped_column(String(200))
    email: Mapped[str | None] = mapped_column(String(200))
    role: Mapped[str] = mapped_column(String(20), default="User")  # Admin, User
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    permissions: Mapped[list["RolePermission"]] = relationship(
        "RolePermission", back_populates="user", cascade="all, delete-orphan"
    )


class RolePermission(Base):
    __tablename__ = "role_permissions"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("master.users.id", ondelete="CASCADE"))
    module: Mapped[str] = mapped_column(String(50), nullable=False)
    can_view: Mapped[bool] = mapped_column(Boolean, default=True)
    can_create: Mapped[bool] = mapped_column(Boolean, default=False)
    can_edit: Mapped[bool] = mapped_column(Boolean, default=False)
    can_delete: Mapped[bool] = mapped_column(Boolean, default=False)
    can_print: Mapped[bool] = mapped_column(Boolean, default=True)

    user: Mapped["User"] = relationship("User", back_populates="permissions")


class Company(Base):
    __tablename__ = "company"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    address: Mapped[str | None] = mapped_column(Text)
    city: Mapped[str | None] = mapped_column(String(100))
    state: Mapped[str | None] = mapped_column(String(100))
    pincode: Mapped[str | None] = mapped_column(String(10))
    phone: Mapped[str | None] = mapped_column(String(30))
    mobile: Mapped[str | None] = mapped_column(String(30))
    email: Mapped[str | None] = mapped_column(String(200))
    gstin: Mapped[str | None] = mapped_column(String(20))
    pan: Mapped[str | None] = mapped_column(String(20))
    tan: Mapped[str | None] = mapped_column(String(20))
    financial_year_start_month: Mapped[int] = mapped_column(Integer, default=4)  # April
    logo_path: Mapped[str | None] = mapped_column(Text)
    
    show_logo: Mapped[bool] = mapped_column(Boolean, default=True)
    voucher_paper_size: Mapped[str] = mapped_column(String(10), default="A5")
    inward_paper_size: Mapped[str] = mapped_column(String(10), default="A4")
    outward_paper_size: Mapped[str] = mapped_column(String(10), default="A5")
    bill_paper_size: Mapped[str] = mapped_column(String(10), default="A4")
    report_paper_size: Mapped[str] = mapped_column(String(10), default="A4")
    grid_paper_size: Mapped[str] = mapped_column(String(10), default="A4")
    
    voucher_title: Mapped[str | None] = mapped_column(String(200), default="Voucher Receipt")
    voucher_terms: Mapped[str | None] = mapped_column(Text, default="1. Subject to local jurisdiction.\n2. This is a computer-generated voucher and requires no physical signature.")
    inward_title: Mapped[str | None] = mapped_column(String(200), default="Inward Challan")
    inward_terms: Mapped[str | None] = mapped_column(Text, default="1. Received goods are subject to count & quality checks.\n2. Report discrepancies within 24 hours.")
    outward_title: Mapped[str | None] = mapped_column(String(200), default="Delivery Note")
    outward_terms: Mapped[str | None] = mapped_column(Text, default="1. Goods once sold/delivered cannot be taken back.\n2. Subject to company terms of carriage.")
    bill_title: Mapped[str | None] = mapped_column(String(200), default="Labour Bill Invoice")
    bill_terms: Mapped[str | None] = mapped_column(Text, default="1. Payment terms: Net 15 days.\n2. Interest @ 18% p.a. will be charged for delayed payments.")

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )


class FinancialYear(Base):
    __tablename__ = "financial_years"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    year_str: Mapped[str] = mapped_column(String(20), unique=True, nullable=False)  # e.g. 2026_2027
    label: Mapped[str] = mapped_column(String(50))  # e.g. "2026-2027"
    start_date: Mapped[str] = mapped_column(String(10))  # YYYY-MM-DD
    end_date: Mapped[str] = mapped_column(String(10))
    is_active: Mapped[bool] = mapped_column(Boolean, default=False)
    is_locked: Mapped[bool] = mapped_column(Boolean, default=False)
    schema_name: Mapped[str] = mapped_column(String(50))  # fy_2026_2027
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class LedgerGroup(Base):
    __tablename__ = "ledger_groups"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(200), unique=True, nullable=False)
    parent_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("master.ledger_groups.id"))
    group_type: Mapped[str] = mapped_column(String(20), default="Liability")
    # Assets, Liability, Income, Expense
    is_system: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    ledgers: Mapped[list["Ledger"]] = relationship("Ledger", back_populates="group")
    children: Mapped[list["LedgerGroup"]] = relationship(
        "LedgerGroup", back_populates="parent"
    )
    parent: Mapped["LedgerGroup | None"] = relationship(
        "LedgerGroup", back_populates="children", remote_side="LedgerGroup.id"
    )


class Ledger(Base):
    __tablename__ = "ledgers"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(200), nullable=False, index=True)
    ledger_code: Mapped[str | None] = mapped_column(String(50), unique=True)
    group_id: Mapped[int] = mapped_column(Integer, ForeignKey("master.ledger_groups.id"))
    ledger_type: Mapped[str] = mapped_column(String(20), default="Account")
    # Account, Staff, Contractor
    opening_balance: Mapped[float] = mapped_column(Numeric(15, 2), default=0)
    balance_type: Mapped[str] = mapped_column(String(2), default="Dr")  # Dr, Cr
    phone: Mapped[str | None] = mapped_column(String(30))
    mobile: Mapped[str | None] = mapped_column(String(30))
    address: Mapped[str | None] = mapped_column(Text)
    city: Mapped[str | None] = mapped_column(String(100))
    pincode: Mapped[str | None] = mapped_column(String(10))
    state: Mapped[str | None] = mapped_column(String(100))
    gstin: Mapped[str | None] = mapped_column(String(20))
    pan: Mapped[str | None] = mapped_column(String(20))
    bank_name: Mapped[str | None] = mapped_column(String(200))
    bank_account_no: Mapped[str | None] = mapped_column(String(50))
    bank_ifsc: Mapped[str | None] = mapped_column(String(20))
    designation: Mapped[str | None] = mapped_column(String(100))
    # For Staff
    department: Mapped[str | None] = mapped_column(String(100))
    basic_salary: Mapped[float | None] = mapped_column(Numeric(15, 2))
    join_date: Mapped[str | None] = mapped_column(String(10))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    group: Mapped["LedgerGroup"] = relationship("LedgerGroup", back_populates="ledgers")


class UnitOfMeasure(Base):
    __tablename__ = "units_of_measure"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)
    symbol: Mapped[str] = mapped_column(String(10), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class StockItem(Base):
    __tablename__ = "stock_items"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(200), nullable=False, unique=True)
    item_code: Mapped[str | None] = mapped_column(String(50), unique=True)
    uom_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("master.units_of_measure.id"))
    opening_stock: Mapped[float] = mapped_column(Numeric(15, 3), default=0)
    reorder_level: Mapped[float] = mapped_column(Numeric(15, 3), default=0)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    uom: Mapped["UnitOfMeasure | None"] = relationship("UnitOfMeasure")


class Product(Base):
    __tablename__ = "products"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    product_code: Mapped[str | None] = mapped_column(String(50), unique=True)
    description: Mapped[str | None] = mapped_column(Text)
    uom_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("master.units_of_measure.id"))
    weight: Mapped[float | None] = mapped_column(Numeric(15, 3), default=0)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    uom: Mapped["UnitOfMeasure | None"] = relationship("UnitOfMeasure")
    processes: Mapped[list["Process"]] = relationship("Process", back_populates="product")


class Process(Base):
    __tablename__ = "processes"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    process_code: Mapped[str | None] = mapped_column(String(50))
    product_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("master.products.id"))
    sequence: Mapped[int] = mapped_column(Integer, default=0)
    company_rate: Mapped[float] = mapped_column(Numeric(15, 4), default=0)
    contractor_rate: Mapped[float] = mapped_column(Numeric(15, 4), default=0)
    gst_percent: Mapped[float] = mapped_column(Numeric(5, 2), default=0.0)
    description: Mapped[str | None] = mapped_column(Text)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    process_ids: Mapped[str | None] = mapped_column(String(200), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    product: Mapped["Product | None"] = relationship("Product", back_populates="processes")
    rates: Mapped[list["Rate"]] = relationship("Rate", back_populates="process")


class Rate(Base):
    __tablename__ = "rates"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    process_id: Mapped[int] = mapped_column(Integer, ForeignKey("master.processes.id"))
    ledger_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("master.ledgers.id"))
    product_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("master.products.id"))
    # Contractor ledger this rate applies to (null = default rate)
    rate: Mapped[float] = mapped_column(Numeric(15, 4), default=0)
    uom_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("master.units_of_measure.id"))
    effective_from: Mapped[str | None] = mapped_column(String(10))
    effective_to: Mapped[str | None] = mapped_column(String(10))
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    process: Mapped["Process"] = relationship("Process", back_populates="rates")
    uom: Mapped["UnitOfMeasure | None"] = relationship("UnitOfMeasure")
    product: Mapped["Product | None"] = relationship("Product")


class Location(Base):
    __tablename__ = "locations"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    code: Mapped[str | None] = mapped_column(String(50))
    process_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("master.processes.id"), nullable=True)
    p1_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("master.ledgers.id"), nullable=True)
    p1_from: Mapped[str | None] = mapped_column(String(10), nullable=True)
    p1_to: Mapped[str | None] = mapped_column(String(10), nullable=True)
    p2_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("master.ledgers.id"), nullable=True)
    p2_from: Mapped[str | None] = mapped_column(String(10), nullable=True)
    p2_to: Mapped[str | None] = mapped_column(String(10), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    process: Mapped["Process | None"] = relationship("Process")


class DocumentSequence(Base):
    __tablename__ = "document_sequences"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    document_type: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)
    prefix: Mapped[str] = mapped_column(String(20), default="")
    suffix: Mapped[str] = mapped_column(String(20), default="")
    current_number: Mapped[int] = mapped_column(Integer, default=0)
    padding_width: Mapped[int] = mapped_column(Integer, default=3)

