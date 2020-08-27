"""empty message

Revision ID: 96091745f0be
Revises: dd38dd3904c1
Create Date: 2020-01-31 16:25:06.834752

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '96091745f0be'
down_revision = 'dd38dd3904c1'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_constraint(None, 'line_command', type_='foreignkey')
    op.create_foreign_key(None, 'line_command', 'mobile_operator', ['line_id'], ['id'])
    op.add_column('transaction_detail', sa.Column('customer_name', sa.String(), nullable=False))
    op.alter_column('transaction_detail', 'transaction_reason',
               existing_type=sa.VARCHAR(),
               nullable=False)
    op.add_column('user', sa.Column('day_first_log', sa.Boolean(), nullable=False))
    op.add_column('user', sa.Column('first_time_login', sa.Boolean(), nullable=False))
    op.drop_column('user', 'user_code')
    op.add_column('user_transaction', sa.Column('system_float_after', sa.Integer(), nullable=False))
    op.add_column('user_transaction', sa.Column('system_float_before', sa.Integer(), nullable=False))
    op.add_column('user_transaction', sa.Column('user_float_amount', sa.Integer(), nullable=False))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('user_transaction', 'user_float_amount')
    op.drop_column('user_transaction', 'system_float_before')
    op.drop_column('user_transaction', 'system_float_after')
    op.add_column('user', sa.Column('user_code', sa.VARCHAR(length=60), nullable=False))
    op.drop_column('user', 'first_time_login')
    op.drop_column('user', 'day_first_log')
    op.alter_column('transaction_detail', 'transaction_reason',
               existing_type=sa.VARCHAR(),
               nullable=True)
    op.drop_column('transaction_detail', 'customer_name')
    op.drop_constraint(None, 'line_command', type_='foreignkey')
    op.create_foreign_key(None, 'line_command', 'money_line', ['line_id'], ['id'])
    # ### end Alembic commands ###
