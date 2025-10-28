let clientTransactionItem = null;

export const setTransactionClient = (client) => {
  clientTransactionItem = client;
};

export const createOrderItem = async (order_id, product_id, quantity, price) => {
  if (!clientTransactionItem) throw new Error("Transação não iniciada");

  const res = await clientTransactionItem.query(
    `INSERT INTO order_items (order_id, product_id, quantity, price)
     VALUES ($1, $2, $3, $4) RETURNING *`,
    [order_id, product_id, quantity, price]
  );
  return res.rows[0];
};