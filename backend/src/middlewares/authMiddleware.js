import jwt from "jsonwebtoken";

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;
  console.log("[AUTH] Authorization header:", authHeader); // 🔹 log

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    console.log("[AUTH] Token não fornecido");
    const error = new Error("Token não fornecido");
    error.statusCode = 401;
    return next(error);
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    console.log("[AUTH] Token decodificado:", decoded); // 🔹 log
    req.user = decoded;
    next();
  } catch (err) {
    console.log("[AUTH] Token inválido", err);
    const error = new Error("Token inválido");
    error.statusCode = 401;
    return next(error);
  }
};

export default authMiddleware;
