-- =============================================================================
-- NEON IMPORT — Dados demo do Management-SaaS
-- Cole e execute no SQL Editor do Neon
-- =============================================================================

-- =============================================================================
-- USERS
-- =============================================================================
INSERT INTO users (id, name, email, password, role, created_at) VALUES
  (1,  'João Admin',           'joao.atualizado@email.com', '$2b$10$k6mac8TjW5ewSwLEeEsUheID.kOwFcwYWJk2wwaA4OIYNlU1eXF0a', 'admin', '2025-09-16 22:07:34'),
  (2,  'Maria Silva',          'maria@email.com',            '$2b$10$ZZfmYEB.hPep4d/wqAbhUOMqz4TsuL9MHGwqNWWekcbiY8vTbzhA.', 'user',  '2025-09-16 22:11:46'),
  (4,  'José Pereira',         'jose@email.com',             '$2b$10$vWrO5ZPCFMjGggVGqlpyl.a/5qZcPTabZpK9mHXJyQ/N.Ha1L34ie', 'user',  '2025-09-17 16:49:47'),
  (7,  'Admin Sistema',        'admin@seuapp.com',           '$2b$10$kpgjRUwnr1OMQl9zTbI6Neo3HXwgOOtAIObCNmIYbALlgGgDMlNky', 'admin', '2025-10-17 22:16:22'),
  (8,  'Usuário Teste',        'teste@mail.com',             '$2b$10$p/r8WFsBC/3fOqL6loxaM.r2ZmMAKiFIp48RyYh1Yb6KOi6nOnP0S', 'user',  '2025-10-22 15:29:50'),
  (9,  'Admin',                'admin@managesaas.com',       '$2b$12$G1PMX.RHF1GUuj5ZH//S0ONEkvJWDlOl6nS89UkBNLTUu3K6.FDOe', 'admin', '2026-03-23 15:28:53')
ON CONFLICT (email) DO NOTHING;

SELECT setval('users_id_seq', 10, true);

-- =============================================================================
-- CLIENTS
-- =============================================================================
INSERT INTO clients (id, name, email, phone, address, created_at) VALUES
  (2,  'Empresa ABC',                    'contato@empresaabc.com',             '+55 11 99999-8888', 'Rua A, 123, São Paulo',                                        '2025-09-17 15:27:28'),
  (5,  'Google',                         'google@google.com',                  NULL,                NULL,                                                            '2025-11-07 18:01:35'),
  (6,  'Microsoft',                      'mocrosoft@microsoft.com',            NULL,                NULL,                                                            '2025-11-07 18:01:59'),
  (7,  'Meta',                           'meta@meta.com',                      NULL,                NULL,                                                            '2025-11-07 18:02:07'),
  (9,  'Loja Tech Center',               'contato@techcenter.com.br',          '+55 21 98888-7777', 'Av. Atlântica, 500, Copacabana, Rio de Janeiro - RJ',           '2026-03-18 16:16:51'),
  (10, 'Distribuidora Digital Max',      'vendas@digitalmax.com.br',           '+55 31 97777-6666', 'Rua das Flores, 250, Savassi, Belo Horizonte - MG',             '2026-03-18 16:17:04'),
  (11, 'Shopping Eletrônicos Prime',     'prime@shoppingeletronicos.com.br',   '+55 41 96666-5555', 'Av. das Torres, 1200, Centro, Curitiba - PR',                   '2026-03-18 16:17:17'),
  (12, 'Conecta Solutions',              'suporte@conectasolutions.com.br',    '+55 51 95555-4444', 'Rua Independência, 45, Cidade Baixa, Porto Alegre - RS',        '2026-03-18 16:17:29'),
  (13, 'Rede SmartHouse',                'compras@smarthouse.com.br',          '+55 62 94444-3333', 'Av. Goiás, 789, Setor Central, Goiânia - GO',                  '2026-03-18 16:17:41'),
  (14, 'TechWorld Comércio Ltda',        'contato@techworld.com.br',           '+55 11 98888-1111', 'Av. Paulista, 1500, Bela Vista, São Paulo - SP',                '2026-03-18 16:18:05'),
  (16, 'Eletrônicos Nova Era',           'vendas@novaeraeletronicos.com.br',   '+55 21 97777-2222', 'Rua das Laranjeiras, 300, Laranjeiras, Rio de Janeiro - RJ',    '2026-03-18 16:18:28'),
  (17, 'Digital House Distribuidora',    'suporte@digitalhouse.com.br',        '+55 31 96666-3333', 'Av. Afonso Pena, 1200, Centro, Belo Horizonte - MG',            '2026-03-18 16:18:39'),
  (18, 'MegaTech Solutions',             'compras@megatech.com.br',            '+55 41 95555-4444', 'Rua XV de Novembro, 789, Centro, Curitiba - PR',                '2026-03-18 16:18:51'),
  (19, 'SmartShop Eletrônicos',          'atendimento@smartshop.com.br',       '+55 51 94444-5555', 'Av. Ipiranga, 2000, Jardim Botânico, Porto Alegre - RS',        '2026-03-18 16:19:08'),
  (20, 'Conecta Digital Ltda',           'contato@conectadigital.com.br',      '+55 62 93333-6666', 'Av. Anhanguera, 500, Setor Central, Goiânia - GO',              '2026-03-18 16:19:20'),
  (21, 'Infinity Tech Comércio',         'vendas@infinitytech.com.br',         '+55 85 92222-7777', 'Rua Floriano Peixoto, 250, Centro, Fortaleza - CE',             '2026-03-18 16:19:35'),
  (22, 'Prime Eletrônicos S.A.',         'prime@eletronicosprime.com.br',      '+55 71 91111-8888', 'Av. Tancredo Neves, 1000, Caminho das Árvores, Salvador - BA', '2026-03-18 16:19:47'),
  (23, 'DigitalMax Importadora',         'importadora@digitalmax.com.br',      '+55 95 90000-9999', 'Av. Getúlio Vargas, 400, Centro, Manaus - AM',                  '2026-03-18 16:19:59'),
  (24, 'TechStore Brasil',               'compras@techstore.com.br',           '+55 48 98888-0000', 'Rua Hercílio Luz, 350, Centro, Florianópolis - SC',             '2026-03-18 16:20:10')
ON CONFLICT (email) DO NOTHING;

SELECT setval('clients_id_seq', 25, true);

-- =============================================================================
-- SUPPLIERS
-- =============================================================================
INSERT INTO suppliers (id, name, email, phone, document, contact_name, notes, created_at) VALUES
  (1, 'Distribuidora Alpha Ltda',                  'carlos@alpha.com.br',          '(11) 98765-4321', '12.345.678/0001-99', 'Carlos Mendes',   'Fornecedor principal de eletrônicos',              '2026-03-18 15:57:18-03'),
  (2, 'Eletrônica Global Ltda',                    'andre@eletronicaglobal.com.br', '(11) 3344-7788',  '14.567.890/0001-33', 'André Souza',     'Distribuidora de componentes eletrônicos importados','2026-03-18 15:59:50-03'),
  (3, 'Digital Tech Comércio S.A.',                'luciana@digitaltech.com.br',   '(21) 99876-2233', '22.345.678/0001-55', 'Luciana Torres',  'Fornecedor de notebooks e acessórios',             '2026-03-18 16:00:09-03'),
  (4, 'Alpha Chips Indústria Ltda',                'roberto@alphachips.com.br',    '(31) 4455-6677',  '33.456.789/0001-77', 'Roberto Lima',    'Fabricante de semicondutores e placas eletrônicas','2026-03-18 16:00:27-03'),
  (5, 'Smart Devices Brasil Ltda',                 'carla@smartdevices.com.br',    '(41) 91234-5566', '44.567.890/0001-99', 'Carla Menezes',   'Distribuidora de smartphones e tablets',           '2026-03-18 16:00:45-03'),
  (6, 'AudioVision Equipamentos Eletrônicos Ltda', 'felipe@audiovision.com.br',    '(51) 3344-8899',  '55.678.901/0001-11', 'Felipe Andrade',  'Fornecedor de sistemas de som e vídeo',            '2026-03-18 16:01:10-03')
ON CONFLICT (email) DO NOTHING;

SELECT setval('suppliers_id_seq', 7, true);

-- =============================================================================
-- PRODUCTS
-- =============================================================================
INSERT INTO products (id, name, description, price, created_at) VALUES
  (2,  'Notebook Gamer',             NULL,                                                                    4500.00, '2025-09-17 15:28:00'),
  (3,  'Mouse s/ Fio',               NULL,                                                                     200.00, '2025-09-17 15:31:48'),
  (5,  'Mouse Gamer',                NULL,                                                                     199.90, '2025-09-17 16:04:51'),
  (6,  'Teclado Mecânico',           NULL,                                                                     399.99, '2025-09-17 16:04:57'),
  (8,  'Smartphone Galaxy S25+',     'Samsung Galaxy S24 com 512GB de armazenamento',                        6700.00, '2025-10-22 15:44:47'),
  (12, 'Produto Teste',              NULL,                                                                      10.00, '2025-10-28 16:36:58'),
  (15, 'Smartphone Galaxy S24',      'Samsung Galaxy S24 com 256GB de armazenamento',                        5200.00, '2026-03-18 16:02:21'),
  (16, 'Monitor UltraWide LG 34"',   'Monitor LG UltraWide 34 polegadas, resolução 3440x1440',               2800.00, '2026-03-18 16:02:37'),
  (17, 'Headset Gamer HyperX Cloud II','Headset com som surround 7.1 e microfone removível',                  650.00, '2026-03-18 16:02:50'),
  (18, 'Smartwatch Apple Watch Series 9','Apple Watch com GPS, monitor cardíaco e tela OLED',               3900.00, '2026-03-18 16:03:06'),
  (19, 'Console PlayStation 5 Slim', 'Sony PlayStation 5 Slim, 1TB SSD, suporte a jogos 4K',                4700.00, '2026-03-18 16:03:17'),
  (20, 'Caixa de Som JBL Charge 5',  'Caixa de som portátil JBL Charge 5 com Bluetooth e bateria de longa duração', 950.00, '2026-03-18 16:03:31')
ON CONFLICT DO NOTHING;

SELECT setval('products_id_seq', 21, true);

-- =============================================================================
-- STOCK
-- =============================================================================
INSERT INTO stock (id, product_id, quantity, last_updated) VALUES
  (2,  2,  15, '2026-03-13 14:29:13'),
  (3,  3,  16, '2026-03-18 21:41:54'),
  (5,  12, 13, '2025-11-10 17:41:38'),
  (6,  8,   1, '2026-03-18 21:46:49'),
  (7,  5,   8, '2026-03-18 16:23:41'),
  (8,  6,  19, '2026-03-18 21:38:46'),
  (9,  15, 30, '2026-03-18 16:02:22'),
  (10, 16, 12, '2026-03-18 16:02:37'),
  (11, 17, 49, '2026-03-18 17:01:00'),
  (12, 18, 20, '2026-03-18 16:03:06'),
  (13, 19,  3, '2026-03-18 16:39:40'),
  (14, 20, 40, '2026-03-18 21:47:57')
ON CONFLICT (product_id) DO UPDATE SET quantity = EXCLUDED.quantity, last_updated = EXCLUDED.last_updated;

SELECT setval('stock_id_seq', 15, true);

-- =============================================================================
-- ORDERS
-- =============================================================================
INSERT INTO orders (id, client_id, user_id, total, status, created_at, updated_at) VALUES
  (2,  22, 1, 8601.98,  'enviado',   '2025-09-17 15:34:54', '2026-03-18 16:22:40'),
  (3,  10, 1, 8801.97,  'entregue',  '2025-09-17 16:09:29', '2026-03-18 16:22:47'),
  (6,  20, 7, 4500.00,  'concluído', '2025-10-22 16:30:49', '2026-03-18 16:22:53'),
  (7,  23, 7, 4500.00,  'cancelado', '2025-10-22 17:02:45', '2026-03-18 16:22:58'),
  (16, 17, 7,  829.98,  'concluído', '2025-11-07 18:39:31', '2026-03-18 16:23:16'),
  (19, 17, 7,  399.99,  'concluído', '2025-11-10 18:23:46', '2026-03-18 16:23:21'),
  (24, 20, 7,  200.00,  'estornado', '2025-11-10 18:44:55', '2026-03-18 16:23:26'),
  (25, 16, 7,  199.90,  'pendente',  '2025-11-11 16:43:49', '2026-03-18 16:23:30'),
  (26, 20, 7,  399.80,  'pendente',  '2026-03-12 21:01:24', '2026-03-18 16:23:35'),
  (27,  9, 7,  399.80,  'pago',      '2026-03-12 21:18:55', '2026-03-18 16:23:41'),
  (28, 21, 7,  200.00,  'pendente',  '2026-03-12 21:30:15', '2026-03-18 16:23:50'),
  (29, 20, 7, 18850.00, 'pago',      '2026-03-18 16:20:59', '2026-03-18 16:20:59'),
  (30, 16, 7, 59900.00, 'concluído', '2026-03-18 16:21:54', '2026-03-18 16:21:54'),
  (31, 18, 7, 18850.00, 'concluído', '2026-03-18 16:24:37', '2026-03-18 16:24:37'),
  (32, 21, 7,  8400.00, 'concluído', '2026-03-18 16:24:48', '2026-03-18 16:24:48'),
  (33, 10, 7,  1199.40, 'concluído', '2026-03-18 16:40:34', '2026-03-18 16:40:34'),
  (34, 20, 7,   650.00, 'concluído', '2026-03-18 17:01:00', '2026-03-18 17:01:00'),
  (35, 16, 7,   950.00, 'pago',      '2026-03-18 17:30:58', '2026-03-18 17:30:58')
ON CONFLICT DO NOTHING;

SELECT setval('orders_id_seq', 36, true);

-- =============================================================================
-- ORDER ITEMS
-- =============================================================================
INSERT INTO order_items (id, order_id, product_id, quantity, price) VALUES
  (104, 29, 18, 4, 3900.00),
  (105, 29, 17, 5,  650.00),
  (106, 30, 19, 5, 4700.00),
  (107, 30, 16, 7, 2800.00),
  (111,  2,  3, 1,  200.00),
  (112,  2,  2, 2, 4200.99),
  (113,  3,  2, 2, 4200.99),
  (114,  3,  3, 1,  399.99),
  (115,  6,  2, 1, 4500.00),
  (116,  7,  2, 1, 4500.00),
  (117, 16, 12, 3,   10.00),
  (118, 16,  6, 2,  399.99),
  (119, 19,  6, 1,  399.99),
  (120, 24,  3, 1,  200.00),
  (121, 25,  5, 1,  199.90),
  (122, 26,  5, 2,  199.90),
  (123, 27,  5, 2,  199.90),
  (124, 28,  3, 1,  200.00),
  (125, 31, 17, 5,  650.00),
  (126, 31, 15, 3, 5200.00),
  (127, 32, 16, 3, 2800.00),
  (128, 33,  5, 6,  199.90),
  (129, 34, 17, 1,  650.00),
  (130, 35, 20, 1,  950.00)
ON CONFLICT DO NOTHING;

SELECT setval('order_items_id_seq', 131, true);

-- =============================================================================
-- PURCHASE ORDERS
-- =============================================================================
INSERT INTO purchase_orders (id, supplier_id, user_id, total, status, notes, created_at, updated_at) VALUES
  (5, 6, 7, 3300.00, 'recebido', NULL, '2026-03-18 21:47:55-03', '2026-03-18 21:47:57-03')
ON CONFLICT DO NOTHING;

SELECT setval('purchase_orders_id_seq', 6, true);

-- =============================================================================
-- PURCHASE ORDER ITEMS
-- =============================================================================
INSERT INTO purchase_order_items (id, purchase_order_id, product_id, quantity, unit_cost) VALUES
  (5, 5, 20, 1, 3300.00)
ON CONFLICT DO NOTHING;

SELECT setval('purchase_order_items_id_seq', 6, true);

-- =============================================================================
-- TRANSACTION CATEGORIES
-- =============================================================================
INSERT INTO transaction_categories (id, name, type) VALUES
  (1,  'Venda de produto',  'receita'),
  (2,  'Serviço prestado',  'receita'),
  (3,  'Outros (receita)',  'receita'),
  (4,  'Fornecedor',        'despesa'),
  (5,  'Aluguel',           'despesa'),
  (6,  'Salários',          'despesa'),
  (7,  'Marketing',         'despesa'),
  (8,  'Logística',         'despesa'),
  (9,  'Impostos',          'despesa'),
  (10, 'Manutenção',        'despesa'),
  (11, 'Outros (despesa)',  'despesa')
ON CONFLICT (name) DO NOTHING;

SELECT setval('transaction_categories_id_seq', 12, true);

-- =============================================================================
-- TRANSACTIONS
-- =============================================================================
INSERT INTO transactions (id, type, description, amount, due_date, paid_date, status, category_id, order_id, client_id, supplier_id, user_id, notes, created_at, updated_at) VALUES
  (1,  'despesa', 'Aluguel de março',                          1500.00, '2026-03-18', '2026-03-18', 'pago',    5,  NULL, NULL, NULL, 7, 'Aluguel',               '2026-03-18 17:14:40-03', NULL),
  (2,  'despesa', 'Pagamento manutenção balcão',                882.82, '2026-03-18', '2026-03-18', 'pago',    10, NULL, NULL, NULL, 7, 'Manutenção Balcão',     '2026-03-18 17:15:36-03', NULL),
  (3,  'receita', 'Pedido #35 — Eletrônicos Nova Era',          950.00, '2026-03-18', '2026-03-18', 'pago',    1,  35,   16,   NULL, 7, NULL,                    '2026-03-18 17:30:58-03', NULL),
  (4,  'despesa', 'Pagamento funcionário',                     1800.00, '2026-03-18', '2026-03-18', 'pago',    6,  NULL, NULL, NULL, 7, 'Folha de pagamento',    '2026-03-18 17:32:00-03', NULL),
  (5,  'receita', 'Pedido #2 — Prime Eletrônicos S.A.',        8601.98, '2025-09-17', '2025-09-17', 'pago',    1,  2,    22,   NULL, 1, NULL,                    '2026-03-18 17:36:46-03', NULL),
  (6,  'receita', 'Pedido #3 — Distribuidora Digital Max',     8801.97, '2025-09-17', '2025-09-17', 'pago',    1,  3,    10,   NULL, 1, NULL,                    '2026-03-18 17:36:46-03', NULL),
  (7,  'receita', 'Pedido #6 — Conecta Digital Ltda',          4500.00, '2025-10-22', '2025-10-22', 'pago',    1,  6,    20,   NULL, 7, NULL,                    '2026-03-18 17:36:46-03', NULL),
  (8,  'receita', 'Pedido #16 — Digital House Distribuidora',   829.98, '2025-11-07', '2025-11-07', 'pago',    1,  16,   17,   NULL, 7, NULL,                    '2026-03-18 17:36:46-03', NULL),
  (9,  'receita', 'Pedido #19 — Digital House Distribuidora',   399.99, '2025-11-10', '2025-11-10', 'pago',    1,  19,   17,   NULL, 7, NULL,                    '2026-03-18 17:36:46-03', NULL),
  (10, 'receita', 'Pedido #27 — Loja Tech Center',              399.80, '2026-03-13', '2026-03-13', 'pago',    1,  27,   9,    NULL, 7, NULL,                    '2026-03-18 17:36:46-03', NULL),
  (11, 'receita', 'Pedido #29 — Conecta Digital Ltda',        18850.00, '2026-03-18', '2026-03-18', 'pago',    1,  29,   20,   NULL, 7, NULL,                    '2026-03-18 17:36:46-03', NULL),
  (12, 'receita', 'Pedido #30 — Eletrônicos Nova Era',        59900.00, '2026-03-18', '2026-03-18', 'pago',    1,  30,   16,   NULL, 7, NULL,                    '2026-03-18 17:36:46-03', NULL),
  (13, 'receita', 'Pedido #31 — MegaTech Solutions',          18850.00, '2026-03-18', '2026-03-18', 'pago',    1,  31,   18,   NULL, 7, NULL,                    '2026-03-18 17:36:46-03', NULL),
  (14, 'receita', 'Pedido #32 — Infinity Tech Comércio',       8400.00, '2026-03-18', '2026-03-18', 'pago',    1,  32,   21,   NULL, 7, NULL,                    '2026-03-18 17:36:46-03', NULL),
  (15, 'receita', 'Pedido #33 — Distribuidora Digital Max',    1199.40, '2026-03-18', '2026-03-18', 'pago',    1,  33,   10,   NULL, 7, NULL,                    '2026-03-18 17:36:46-03', NULL),
  (16, 'receita', 'Pedido #34 — Conecta Digital Ltda',          650.00, '2026-03-18', '2026-03-18', 'pago',    1,  34,   20,   NULL, 7, NULL,                    '2026-03-18 17:36:46-03', NULL),
  (17, 'despesa', 'DARF',                                      3759.45, '2026-03-25', NULL,          'pendente',9,  NULL, NULL, NULL, 7, '',                      '2026-03-18 17:37:41-03', '2026-03-19 15:59:50-03'),
  (18, 'despesa', 'Compra #5 — AudioVision Equipamentos',      3300.00, '2026-03-18', '2026-03-19', 'pago',    4,  NULL, NULL, 6,    NULL, NULL,                 '2026-03-18 21:47:57-03', '2026-03-18 21:48:11-03')
ON CONFLICT DO NOTHING;

SELECT setval('transactions_id_seq', 19, true);

-- =============================================================================
-- MIGRATIONS (registro de controle)
-- =============================================================================
INSERT INTO migrations (id, name, applied_at) VALUES
  (1, '001_initial_schema', '2026-03-18 21:24:02-03'),
  (2, '002_suppliers',      '2026-03-18 21:24:02-03'),
  (3, '004_financial',      '2026-03-18 21:34:26-03'),
  (4, '003_clients_address','2026-03-18 21:35:24-03'),
  (5, '005_business_rules', '2026-03-19 17:09:28-03')
ON CONFLICT (name) DO NOTHING;

SELECT setval('migrations_id_seq', 6, true);

