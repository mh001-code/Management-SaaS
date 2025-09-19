import swaggerJsdoc from "swagger-jsdoc";
import swaggerUi from "swagger-ui-express";

const options = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "Management-SaaS API",
      version: "1.0.0",
      description: "Documentação da API para o sistema SaaS de gestão de clientes, produtos, pedidos e estoque",
    },
    servers: [
      {
        url: "http://localhost:5000",
        description: "Servidor local",
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: "http",
          scheme: "bearer",
          bearerFormat: "JWT",
        },
      },
    },
    security: [{ bearerAuth: [] }],
  },
  apis: ["./src/routes/*.js"], // pega as anotações diretamente dos arquivos de rota
};

const specs = swaggerJsdoc(options);

export const swaggerDocs = (app) => {
  app.use("/api/docs", swaggerUi.serve, swaggerUi.setup(specs));
  console.log("Swagger rodando em http://localhost:5000/api/docs");
};