import React, { useEffect, useState } from "react";
import FormContainer from "./FormContainer";
import Button from "./ui/Button";
import Input from "./ui/Input";
import api from "../services/api";
import notificationService from "../services/notificationService";
import errorService from "../services/errorService";
import { formatCurrency, formatCurrencyValue } from "../utils/formatCurrency";

const OrderForm = ({ onOrderCreated, editingOrder, onCancel }) => {
  const [clients, setClients] = useState([]);
  const [products, setProducts] = useState([]);
  const [items, setItems] = useState([]);
  const [selectedClientId, setSelectedClientId] = useState("");
  const [selectedProduct, setSelectedProduct] = useState("");
  const [quantity, setQuantity] = useState(1);
  const [status, setStatus] = useState("pendente");
  const [isSubmitting, setIsSubmitting] = useState(false);

  // ✅ Buscar clientes e produtos (sem headers duplicados)
  useEffect(() => {
    const fetchData = async () => {
      try {
        const [clientsRes, productsRes] = await Promise.all([
          api.get("/clients"),
          api.get("/products"),
        ]);
        setClients(clientsRes.data);
        setProducts(productsRes.data);
      } catch (err) {
        notificationService.error("Erro ao carregar dados");
      }
    };
    fetchData();
  }, []);

  // ✅ Carregar dados do pedido em edição
  useEffect(() => {
    if (editingOrder) {
      setSelectedClientId(editingOrder.client_id);
      setStatus(editingOrder.status || "pendente");
      setItems(editingOrder.items?.map(it => ({ 
        ...it, 
        reserved_quantity: it.quantity 
      })) || []);
    } else {
      setSelectedClientId("");
      setStatus("pendente");
      setItems([]);
    }
  }, [editingOrder]);

  const handleAddItem = () => {
    if (!selectedProduct || quantity <= 0) return;

    const product = products.find((p) => p.id === Number(selectedProduct));
    if (!product) return;

    const existingItem = items.find((it) => it.product_id === product.id);
    const alreadyInOrder = existingItem ? existingItem.quantity : 0;

    const available = product.stock_quantity ?? product.stock ?? 0;
    const totalRequested = alreadyInOrder + Number(quantity);
    const allowed = available + (existingItem ? existingItem.quantity : 0);

    if (totalRequested > allowed) {
      notificationService.error(`Estoque insuficiente! Disponível: ${allowed}`);
      return;
    }

    setItems((prev) => {
      if (existingItem) {
        return prev.map((it) =>
          it.product_id === product.id
            ? { ...it, quantity: totalRequested }
            : it
        );
      }
      return [
        ...prev,
        {
          product_id: product.id,
          quantity: Number(quantity),
          price: Number(product.price),
        },
      ];
    });

    setSelectedProduct("");
    setQuantity(1);
  };

  const handleRemoveItem = (index) => {
    setItems((prev) => prev.filter((_, i) => i !== index));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!selectedClientId || !items.length) {
      notificationService.error("Cliente e itens são obrigatórios");
      return;
    }

    setIsSubmitting(true);
    try {
      if (editingOrder) {
        await api.put(`/orders/${editingOrder.id}`, {
          client_id: Number(selectedClientId),
          items,
          status,
        });
        notificationService.success("Pedido atualizado com sucesso!");
        onCancel();
      } else {
        await api.post("/orders", {
          client_id: Number(selectedClientId),
          items,
          status,
        });
        notificationService.success("Pedido criado com sucesso!");
      }
      setItems([]);
      setSelectedClientId("");
      onOrderCreated();
    } catch (err) {
      const message = errorService.handle(err, "salvar pedido");
      notificationService.error(message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <FormContainer editTarget={editingOrder}>
      <form style={{ width: '100%' }} onSubmit={handleSubmit}>
        {/* Título */}
        <div style={{
          marginBottom: 'var(--space-xl)',
          paddingBottom: 'var(--space-lg)',
          borderBottom: '1px solid var(--color-border)',
        }}>
          <h3 style={{
            fontSize: 'var(--text-lg)',
            fontWeight: '700',
            color: 'var(--color-text)',
            margin: 0,
            fontFamily: 'var(--font-display)',
          }}>
            {editingOrder ? "✏️ Alterar Pedido" : "➕ Lançar Pedido"}
          </h3>
        </div>

        {/* Grid de formulário */}
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
          gap: 'var(--space-lg)',
          marginBottom: 'var(--space-2xl)',
        }}>
          {/* Cliente */}
          <div>
            <label style={{
              display: 'block',
              fontSize: 'var(--text-sm)',
              fontWeight: '600',
              color: 'var(--color-text)',
              marginBottom: 'var(--space-sm)',
              fontFamily: 'var(--font-body)',
            }}>
              Cliente <span style={{ color: 'var(--color-danger)' }}>*</span>
            </label>
            <select
              value={selectedClientId}
              onChange={(e) => setSelectedClientId(e.target.value)}
              required
              style={{
                width: '100%',
                padding: 'var(--space-md) var(--space-lg)',
                backgroundColor: 'var(--color-surface2)',
                border: '1px solid var(--color-border)',
                borderRadius: 'var(--radius-md)',
                color: 'var(--color-text)',
                fontFamily: 'var(--font-body)',
                fontSize: 'var(--text-base)',
                cursor: 'pointer',
                transition: 'all 150ms ease',
              }}
            >
              <option value="">Selecione um cliente...</option>
              {clients.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name}
                </option>
              ))}
            </select>
          </div>

          {/* Status */}
          <div>
            <label style={{
              display: 'block',
              fontSize: 'var(--text-sm)',
              fontWeight: '600',
              color: 'var(--color-text)',
              marginBottom: 'var(--space-sm)',
              fontFamily: 'var(--font-body)',
            }}>
              Status
            </label>
            <select
              value={status}
              onChange={(e) => setStatus(e.target.value)}
              style={{
                width: '100%',
                padding: 'var(--space-md) var(--space-lg)',
                backgroundColor: 'var(--color-surface2)',
                border: '1px solid var(--color-border)',
                borderRadius: 'var(--radius-md)',
                color: 'var(--color-text)',
                fontFamily: 'var(--font-body)',
                fontSize: 'var(--text-base)',
                cursor: 'pointer',
                transition: 'all 150ms ease',
              }}
            >
              <option value="pendente">Pendente</option>
              <option value="pago">Pago</option>
              <option value="enviado">Enviado</option>
              <option value="entregue">Entregue</option>
              <option value="concluído">Concluído</option>
              <option value="cancelado">Cancelado</option>
            </select>
          </div>
        </div>

        {/* Adicionar Produtos */}
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'auto auto 1fr',
          gap: 'var(--space-md)',
          alignItems: 'flex-end',
          marginBottom: 'var(--space-2xl)',
          padding: 'var(--space-lg)',
          backgroundColor: 'var(--color-surface2)',
          borderRadius: 'var(--radius-md)',
          border: '1px solid var(--color-border)',
        }}>
          {/* Seletor de Produto */}
          <div style={{ flex: 1 }}>
            <label style={{
              display: 'block',
              fontSize: 'var(--text-sm)',
              fontWeight: '600',
              color: 'var(--color-text)',
              marginBottom: 'var(--space-sm)',
            }}>
              Produto
            </label>
            <select
              value={selectedProduct}
              onChange={(e) => setSelectedProduct(e.target.value)}
              style={{
                width: '100%',
                padding: 'var(--space-md) var(--space-lg)',
                backgroundColor: 'var(--color-surface)',
                border: '1px solid var(--color-border)',
                borderRadius: 'var(--radius-sm)',
                color: 'var(--color-text)',
                fontFamily: 'var(--font-body)',
                fontSize: 'var(--text-sm)',
                cursor: 'pointer',
              }}
            >
              <option value="">Selecione...</option>
              {products.map((p) => (
                <option
                  key={p.id}
                  value={p.id}
                  disabled={p.stock_quantity <= 0}
                >
                  {p.name} — Est: {p.stock_quantity}, {formatCurrencyValue(p.price)}
                </option>
              ))}
            </select>
          </div>

          {/* Quantidade */}
          <div style={{ width: '100px' }}>
            <label style={{
              display: 'block',
              fontSize: 'var(--text-sm)',
              fontWeight: '600',
              color: 'var(--color-text)',
              marginBottom: 'var(--space-sm)',
            }}>
              Qtd
            </label>
            <Input
              type="number"
              min="1"
              value={quantity}
              onChange={(e) => setQuantity(Number(e.target.value))}
              style={{ width: '100%' }}
            />
          </div>

          {/* Botão Adicionar */}
          <Button
            type="button"
            onClick={handleAddItem}
            variant="info"
            size="md"
            style={{ whiteSpace: 'nowrap' }}
          >
            + Adicionar
          </Button>
        </div>

        {/* Tabela de Itens */}
        {items.length > 0 && (
          <div style={{
            marginBottom: 'var(--space-2xl)',
            overflowX: 'auto',
            borderRadius: 'var(--radius-md)',
            border: '1px solid var(--color-border)',
            backgroundColor: 'var(--color-surface)',
          }}>
            <table style={{
              width: '100%',
              borderCollapse: 'collapse',
              fontSize: 'var(--text-sm)',
            }}>
              <thead>
                <tr style={{
                  backgroundColor: 'var(--color-surface2)',
                  borderBottom: '2px solid var(--color-border)',
                }}>
                  <th style={{
                    padding: 'var(--space-md) var(--space-lg)',
                    textAlign: 'left',
                    fontWeight: '600',
                    color: 'var(--color-text)',
                  }}>
                    Produto
                  </th>
                  <th style={{
                    padding: 'var(--space-md) var(--space-lg)',
                    textAlign: 'center',
                    fontWeight: '600',
                    color: 'var(--color-text)',
                  }}>
                    Qtd
                  </th>
                  <th style={{
                    padding: 'var(--space-md) var(--space-lg)',
                    textAlign: 'right',
                    fontWeight: '600',
                    color: 'var(--color-text)',
                  }}>
                    Preço
                  </th>
                  <th style={{
                    padding: 'var(--space-md) var(--space-lg)',
                    textAlign: 'right',
                    fontWeight: '600',
                    color: 'var(--color-text)',
                  }}>
                    Total
                  </th>
                  <th style={{
                    padding: 'var(--space-md) var(--space-lg)',
                    textAlign: 'center',
                    fontWeight: '600',
                    color: 'var(--color-text)',
                  }}>
                    Ação
                  </th>
                </tr>
              </thead>
              <tbody>
                {items.map((item, i) => {
                  const product = products.find(p => p.id === item.product_id);
                  const itemTotal = item.price * item.quantity;
                  return (
                    <tr 
                      key={i} 
                      style={{
                        borderBottom: '1px solid var(--color-border)',
                        transition: 'all 150ms ease',
                      }}
                      onMouseEnter={(e) => e.currentTarget.style.backgroundColor = 'var(--color-surface2)'}
                      onMouseLeave={(e) => e.currentTarget.style.backgroundColor = 'transparent'}
                    >
                      <td style={{
                        padding: 'var(--space-md) var(--space-lg)',
                        color: 'var(--color-text)',
                      }}>
                        {product?.name || "—"}
                      </td>
                      <td style={{
                        padding: 'var(--space-md) var(--space-lg)',
                        textAlign: 'center',
                      }}>
                        <Input
                          type="number"
                          min="1"
                          value={item.quantity}
                          onChange={(e) => {
                            const newQty = Number(e.target.value);
                            const product = products.find((p) => p.id === item.product_id);

                            if (!product) return;

                            const currentStock = product.stock_quantity ?? product.stock ?? 0;
                            const reserved = item.reserved_quantity || 0;
                            const available = currentStock + reserved;

                            if (newQty > available) {
                              notificationService.error(`Máximo permitido: ${available}`);
                              return;
                            }

                            setItems((prev) =>
                              prev.map((it, idx) =>
                                idx === i ? { ...it, quantity: newQty } : it
                              )
                            );
                          }}
                          style={{ width: '60px', textAlign: 'center' }}
                        />
                      </td>
                      <td style={{
                        padding: 'var(--space-md) var(--space-lg)',
                        textAlign: 'right',
                        color: 'var(--color-text)',
                      }}>
                        {formatCurrency(item.price)}
                      </td>
                      <td style={{
                        padding: 'var(--space-md) var(--space-lg)',
                        textAlign: 'right',
                        fontWeight: '600',
                        color: 'var(--color-text)',
                      }}>
                        {formatCurrency(itemTotal)}
                      </td>
                      <td style={{
                        padding: 'var(--space-md) var(--space-lg)',
                        textAlign: 'center',
                      }}>
                        <Button
                          type="button"
                          onClick={() => handleRemoveItem(i)}
                          variant="danger"
                          size="sm"
                        >
                          🗑
                        </Button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}

        {/* Total */}
        <div style={{
          display: 'flex',
          justifyContent: 'flex-end',
          marginBottom: 'var(--space-2xl)',
          paddingTop: 'var(--space-lg)',
          borderTop: '2px solid var(--color-border)',
        }}>
          <div style={{
            fontSize: 'var(--text-lg)',
            fontWeight: '700',
            color: 'var(--color-text)',
          }}>
            Total: {formatCurrency(items.reduce((sum, i) => sum + i.quantity * i.price, 0))}
          </div>
        </div>

        {/* Botões de Ação */}
        <div style={{
          display: 'flex',
          gap: 'var(--space-md)',
          justifyContent: 'flex-end',
          flexWrap: 'wrap',
        }}>
          {editingOrder && (
            <Button
              type="button"
              onClick={onCancel}
              variant="secondary"
              disabled={isSubmitting}
            >
              ✕ Cancelar
            </Button>
          )}
          <Button
            type="submit"
            variant={editingOrder ? "warning" : "success"}
            disabled={isSubmitting}
          >
            {isSubmitting ? "Processando..." : (editingOrder ? "✓ Atualizar" : "✓ Criar")}
          </Button>
        </div>
      </form>
    </FormContainer>
  );
};

export default OrderForm;