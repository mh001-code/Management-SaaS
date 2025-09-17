// errorHandler.js
const errorHandler = (err, req, res, next) => {
  console.error(err.stack); // log do erro no console

  const statusCode = err.statusCode || 500; // código HTTP
  const message = err.message || "Erro interno do servidor";

  res.status(statusCode).json({
    error: message
  });
};

export default errorHandler;
