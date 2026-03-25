/**
 * seed-demo.js
 * Popula o banco com dados demo realistas para demonstração do sistema.
 * Uso: DATABASE_URL=postgres://... node scripts/seed-demo.js
 */

import pkg from "pg";
import bcrypt from "bcryptjs";
import dotenv from "dotenv";

dotenv.config();

const { Pool } = pkg;

const pool = process.env.DATABASE_URL
  ? new Pool({ connectionString: process.env.DATABASE_URL, ssl: { rejectUnauthorized: false } })
  : new Pool({
      user: process.env.DB_USER,
      host: process.env.DB_HOST,
      database: process.env.DB_NAME,
      password: process.env.DB_PASS,
      port: process.env.DB_PORT,
    });

async function run() {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    console.log("🌱 Iniciando seed de dados demo...\n");

    // =========================================================
    // USUÁRIOS
    // =========================================================
    const senhaAdmin = await bcrypt.hash("demo@admin123", 10);
    const senhaUser  = await bcrypt.hash("demo@user123",  10);

    const { rows: users } = await client.query(`
      INSERT INTO users (name, email, password, role) VALUES
        ('Administrador Demo', 'admin@demo.com',   $1, 'admin'),
        ('Carlos Mendes',      'carlos@demo.com',  $2, 'user'),
        ('Fernanda Lima',      'fernanda@demo.com',$2, 'user')
      ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name
      RETURNING id, name
    `, [senhaAdmin, senhaUser]);

    console.log(`✅ Usuários: ${users.map(u => u.name).join(", ")}`);
    const adminId = users[0].id;

    // =========================================================
    // FORNECEDORES
    // =========================================================
    const { rows: suppliers } = await client.query(`
      INSERT INTO suppliers (name, email, phone, document, contact_name, notes) VALUES
        ('TechSupply Ltda',       'contato@techsupply.com.br',  '(11) 3456-7890', '12.345.678/0001-90', 'Ricardo Alves',   'Fornecedor principal de eletrônicos'),
        ('Distribuidora Brasil',  'vendas@distbrasil.com.br',   '(21) 2345-6789', '98.765.432/0001-10', 'Mariana Costa',   'Produtos de escritório e papelaria'),
        ('Global Imports',        'importacao@globalimports.com','(41) 3344-5566', '45.678.901/0001-23', 'Felipe Souza',    'Importação de acessórios'),
        ('InfoParts',             'compras@infoparts.com.br',   '(31) 4455-6677', '78.901.234/0001-56', 'Patrícia Rocha',  'Componentes e peças de informática')
      ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name
      RETURNING id, name
    `);

    console.log(`✅ Fornecedores: ${suppliers.map(s => s.name).join(", ")}`);

    // =========================================================
    // CLIENTES
    // =========================================================
    const { rows: clients } = await client.query(`
      INSERT INTO clients (name, email, phone, address) VALUES
        ('Empresa Alpha Soluções',   'compras@alpha.com.br',     '(11) 99887-6543', 'Av. Paulista, 1000 - São Paulo/SP'),
        ('Beta Tecnologia ME',       'financeiro@beta.com.br',   '(21) 98877-5432', 'Rua do Catete, 200 - Rio de Janeiro/RJ'),
        ('Gama Comércio Ltda',       'gama@comercio.com.br',     '(41) 97766-4321', 'Al. Dr. Carlos de Carvalho, 300 - Curitiba/PR'),
        ('Delta Serviços S/A',       'delta@servicos.com.br',    '(31) 96655-3210', 'Av. Afonso Pena, 500 - Belo Horizonte/MG'),
        ('Épsilon Varejo',           'epsilon@varejo.com.br',    '(51) 95544-2109', 'Av. Borges de Medeiros, 700 - Porto Alegre/RS'),
        ('Zeta Consultoria',         'zeta@consultoria.com.br',  '(61) 94433-1098', 'SCS Quadra 4, Bloco A - Brasília/DF'),
        ('Eta Indústria Ltda',       'eta@industria.com.br',     '(71) 93322-0987', 'Av. ACM, 800 - Salvador/BA'),
        ('Theta Distribuidora',      'theta@distribuidora.com.br','(81) 92211-9876', 'Av. Agamenon Magalhães, 900 - Recife/PE')
      ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name
      RETURNING id, name
    `);

    console.log(`✅ Clientes: ${clients.length} cadastrados`);

    // =========================================================
    // PRODUTOS
    // =========================================================
    const { rows: products } = await client.query(`
      INSERT INTO products (name, description, price) VALUES
        ('Notebook Pro 15"',         'Notebook Intel i7, 16GB RAM, SSD 512GB',       4899.90),
        ('Monitor Ultrawide 34"',    'Monitor curvo 3440x1440, 144Hz, IPS',           2299.90),
        ('Teclado Mecânico RGB',     'Switches Cherry MX Red, layout ABNT2',           449.90),
        ('Mouse Gamer 16000 DPI',    'Mouse óptico sem fio, 7 botões programáveis',    299.90),
        ('Headset Wireless Pro',     'Áudio 7.1 surround, microfone retrátil',         599.90),
        ('Webcam Full HD 1080p',     'Autofoco, microfone embutido, USB',              249.90),
        ('SSD NVMe 1TB',             'Leitura 3500MB/s, PCIe 3.0',                    489.90),
        ('Memória RAM 16GB DDR4',    'Dual channel 3200MHz, CL16',                    279.90),
        ('Switch 8 Portas Gigabit',  'Plug-and-play, sem gerenciamento',              189.90),
        ('Nobreak 1200VA',           'Tensão bivolt, 6 tomadas protegidas',            649.90),
        ('Cadeira Ergonômica',       'Apoio lombar ajustável, braços 4D',            1299.90),
        ('Mesa de Escritório 140cm', 'Tampo MDF 25mm, suporte monitor incluso',       799.90)
      ON CONFLICT DO NOTHING
      RETURNING id, name, price
    `);

    // Buscar os produtos se já existiam
    const { rows: allProducts } = await client.query(`
      SELECT id, name, price FROM products ORDER BY id LIMIT 12
    `);

    console.log(`✅ Produtos: ${allProducts.length} cadastrados`);

    // =========================================================
    // ESTOQUE
    // =========================================================
    for (const p of allProducts) {
      const qty = Math.floor(Math.random() * 80) + 20; // 20 a 100 unidades
      await client.query(`
        INSERT INTO stock (product_id, quantity) VALUES ($1, $2)
        ON CONFLICT (product_id) DO UPDATE SET quantity = $2, last_updated = NOW()
      `, [p.id, qty]);

      await client.query(`
        INSERT INTO stock_movements (product_id, quantity, type, reference_id)
        VALUES ($1, $2, 'entrada_inicial', NULL)
      `, [p.id, qty]);
    }

    console.log(`✅ Estoque: inicializado para ${allProducts.length} produtos`);

    // =========================================================
    // PEDIDOS DE VENDA (últimos 3 meses)
    // =========================================================
    const statusVenda = ['pago', 'pago', 'pago', 'entregue', 'enviado', 'pendente', 'concluído', 'cancelado'];
    const orderIds = [];

    const datesVenda = [
      '2026-01-05', '2026-01-12', '2026-01-18', '2026-01-25',
      '2026-02-03', '2026-02-10', '2026-02-17', '2026-02-24',
      '2026-03-03', '2026-03-10', '2026-03-14', '2026-03-20',
    ];

    for (let i = 0; i < datesVenda.length; i++) {
      const client_id = clients[i % clients.length].id;
      const status    = statusVenda[i % statusVenda.length];

      // Selecionar 1-3 produtos aleatórios
      const numItems = Math.floor(Math.random() * 3) + 1;
      const selectedProducts = allProducts.slice(i % allProducts.length, (i % allProducts.length) + numItems);
      if (selectedProducts.length === 0) continue;

      let total = 0;
      const items = selectedProducts.map(p => {
        const qty = Math.floor(Math.random() * 3) + 1;
        total += p.price * qty;
        return { product_id: p.id, quantity: qty, price: p.price };
      });

      const { rows: [order] } = await client.query(`
        INSERT INTO orders (client_id, user_id, total, status, created_at)
        VALUES ($1, $2, $3, $4, $5::timestamptz)
        RETURNING id
      `, [client_id, adminId, total.toFixed(2), status, datesVenda[i]]);

      orderIds.push({ id: order.id, total, status, date: datesVenda[i], client_id });

      for (const item of items) {
        await client.query(`
          INSERT INTO order_items (order_id, product_id, quantity, price)
          VALUES ($1, $2, $3, $4)
        `, [order.id, item.product_id, item.quantity, item.price]);
      }
    }

    console.log(`✅ Pedidos de venda: ${orderIds.length} criados`);

    // =========================================================
    // PEDIDOS DE COMPRA
    // =========================================================
    const statusCompra = ['recebido', 'recebido', 'confirmado', 'pendente'];
    const datesPO = [
      '2026-01-08', '2026-01-20', '2026-02-05',
      '2026-02-19', '2026-03-04', '2026-03-18',
    ];

    for (let i = 0; i < datesPO.length; i++) {
      const supplier_id = suppliers[i % suppliers.length].id;
      const status      = statusCompra[i % statusCompra.length];
      const prod        = allProducts[i % allProducts.length];
      const qty         = Math.floor(Math.random() * 20) + 10;
      const unit_cost   = (prod.price * 0.55).toFixed(2);
      const total       = (unit_cost * qty).toFixed(2);

      const { rows: [po] } = await client.query(`
        INSERT INTO purchase_orders (supplier_id, user_id, total, status, created_at)
        VALUES ($1, $2, $3, $4, $5::timestamptz)
        RETURNING id
      `, [supplier_id, adminId, total, status, datesPO[i]]);

      await client.query(`
        INSERT INTO purchase_order_items (purchase_order_id, product_id, quantity, unit_cost)
        VALUES ($1, $2, $3, $4)
      `, [po.id, prod.id, qty, unit_cost]);
    }

    console.log(`✅ Pedidos de compra: ${datesPO.length} criados`);

    // =========================================================
    // TRANSAÇÕES FINANCEIRAS
    // =========================================================
    const { rows: cats } = await client.query(`SELECT id, name, type FROM transaction_categories`);
    const catReceita  = cats.find(c => c.name === 'Venda de produto');
    const catServico  = cats.find(c => c.name === 'Serviço prestado');
    const catFornec   = cats.find(c => c.name === 'Fornecedor');
    const catAluguel  = cats.find(c => c.name === 'Aluguel');
    const catSalario  = cats.find(c => c.name === 'Salários');
    const catMkt      = cats.find(c => c.name === 'Marketing');
    const catImposto  = cats.find(c => c.name === 'Impostos');

    // Receitas vinculadas aos pedidos pagos
    for (const o of orderIds) {
      if (!['pago', 'entregue', 'concluído'].includes(o.status)) continue;
      await client.query(`
        INSERT INTO transactions (type, description, amount, due_date, paid_date, status, category_id, order_id, client_id, user_id)
        VALUES ('receita', 'Recebimento pedido #' || $1, $2, $3::date, $3::date, 'pago', $4, $1, $5, $6)
      `, [o.id, o.total.toFixed(2), o.date, catReceita.id, o.client_id, adminId]);
    }

    // Receita de serviços
    const servicosReceita = [
      { desc: 'Consultoria de TI - Empresa Alpha',       amount: 3500.00, date: '2026-01-15', status: 'pago',     paid: '2026-01-15' },
      { desc: 'Suporte técnico mensal - Beta Tecnologia', amount: 1200.00, date: '2026-02-05', status: 'pago',     paid: '2026-02-05' },
      { desc: 'Implantação de sistema - Gama Comércio',   amount: 5800.00, date: '2026-02-20', status: 'pago',     paid: '2026-02-20' },
      { desc: 'Treinamento equipe - Delta Serviços',      amount: 2100.00, date: '2026-03-10', status: 'pendente', paid: null         },
      { desc: 'Licença anual sistema - Épsilon Varejo',   amount: 4200.00, date: '2026-03-25', status: 'pendente', paid: null         },
    ];

    for (const s of servicosReceita) {
      await client.query(`
        INSERT INTO transactions (type, description, amount, due_date, paid_date, status, category_id, user_id)
        VALUES ('receita', $1, $2, $3::date, $4, $5, $6, $7)
      `, [s.desc, s.amount, s.date, s.paid, s.status, catServico.id, adminId]);
    }

    // Despesas fixas e variáveis
    const despesas = [
      // Aluguel
      { desc: 'Aluguel escritório - Janeiro',  amount: 3200.00, date: '2026-01-05', cat: catAluguel.id,  status: 'pago',     paid: '2026-01-05' },
      { desc: 'Aluguel escritório - Fevereiro', amount: 3200.00, date: '2026-02-05', cat: catAluguel.id,  status: 'pago',     paid: '2026-02-05' },
      { desc: 'Aluguel escritório - Março',    amount: 3200.00, date: '2026-03-05', cat: catAluguel.id,  status: 'pago',     paid: '2026-03-05' },
      // Salários
      { desc: 'Folha de pagamento - Janeiro',  amount: 8500.00, date: '2026-01-30', cat: catSalario.id,  status: 'pago',     paid: '2026-01-30' },
      { desc: 'Folha de pagamento - Fevereiro',amount: 8500.00, date: '2026-02-28', cat: catSalario.id,  status: 'pago',     paid: '2026-02-28' },
      { desc: 'Folha de pagamento - Março',    amount: 8500.00, date: '2026-03-31', cat: catSalario.id,  status: 'pendente', paid: null         },
      // Fornecedores
      { desc: 'Compra estoque - TechSupply',   amount: 6700.00, date: '2026-01-10', cat: catFornec.id,   status: 'pago',     paid: '2026-01-10' },
      { desc: 'Compra estoque - InfoParts',    amount: 4200.00, date: '2026-02-12', cat: catFornec.id,   status: 'pago',     paid: '2026-02-12' },
      { desc: 'Compra estoque - Global Imports',amount:3800.00, date: '2026-03-08', cat: catFornec.id,   status: 'pago',     paid: '2026-03-08' },
      // Marketing
      { desc: 'Google Ads - Janeiro',          amount:  890.00, date: '2026-01-31', cat: catMkt.id,      status: 'pago',     paid: '2026-01-31' },
      { desc: 'Google Ads - Fevereiro',        amount:  950.00, date: '2026-02-28', cat: catMkt.id,      status: 'pago',     paid: '2026-02-28' },
      { desc: 'Campanha LinkedIn - Março',     amount: 1200.00, date: '2026-03-31', cat: catMkt.id,      status: 'pendente', paid: null         },
      // Impostos
      { desc: 'DAS - Simples Nacional Jan',    amount: 1450.00, date: '2026-01-20', cat: catImposto.id,  status: 'pago',     paid: '2026-01-20' },
      { desc: 'DAS - Simples Nacional Fev',    amount: 1580.00, date: '2026-02-20', cat: catImposto.id,  status: 'pago',     paid: '2026-02-20' },
      { desc: 'DAS - Simples Nacional Mar',    amount: 1620.00, date: '2026-03-20', cat: catImposto.id,  status: 'pendente', paid: null         },
    ];

    for (const d of despesas) {
      await client.query(`
        INSERT INTO transactions (type, description, amount, due_date, paid_date, status, category_id, user_id)
        VALUES ('despesa', $1, $2, $3::date, $4, $5, $6, $7)
      `, [d.desc, d.amount, d.date, d.paid, d.status, d.cat, adminId]);
    }

    const totalTransacoes = orderIds.filter(o => ['pago','entregue','concluído'].includes(o.status)).length
      + servicosReceita.length + despesas.length;

    console.log(`✅ Transações financeiras: ${totalTransacoes} criadas`);

    await client.query("COMMIT");

    console.log("\n🎉 Seed concluído com sucesso!\n");
    console.log("  Acesso admin:");
    console.log("  Email:  admin@demo.com");
    console.log("  Senha:  demo@admin123\n");
    console.log("  Acesso usuário:");
    console.log("  Email:  carlos@demo.com");
    console.log("  Senha:  demo@user123\n");

  } catch (err) {
    await client.query("ROLLBACK");
    console.error("❌ Erro no seed:", err.message);
    throw err;
  } finally {
    client.release();
    await pool.end();
  }
}

run();
