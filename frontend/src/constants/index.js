/**
 * Constantes de mensagens da aplicação
 */

export const MESSAGES = {
  // Erros
  ERROR: {
    FETCH_FAILED: 'Erro ao buscar dados. Por favor, tente novamente.',
    LOGIN_FAILED: 'Credenciais inválidas. Por favor, tente novamente.',
    SAVE_FAILED: 'Erro ao salvar dados. Por favor, tente novamente.',
    DELETE_FAILED: 'Erro ao deletar. Por favor, tente novamente.',
    NETWORK_ERROR: 'Erro de conexão. Verifique sua internet.',
    UNAUTHORIZED: 'Sem permissão para acessar este recurso.',
    UNKNOWN: 'Algo deu errado. Por favor, tente novamente.',
  },

  // Sucesso
  SUCCESS: {
    SAVED: 'Salvo com sucesso!',
    DELETED: 'Deletado com sucesso!',
    UPDATED: 'Atualizado com sucesso!',
    CREATED: 'Criado com sucesso!',
    LOGGED_IN: 'Bem-vindo!',
  },

  // Avisos
  WARNING: {
    CONFIRM_DELETE: 'Tem certeza que deseja deletar? Esta ação não pode ser desfeita.',
    UNSAVED_CHANGES: 'Você tem alterações não salvas.',
  },

  // Info
  INFO: {
    LOADING: 'Carregando...',
    NO_DATA: 'Nenhum dado encontrado.',
  },
};

/**
 * Códigos de erro HTTP
 */
export const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  INTERNAL_ERROR: 500,
};

/**
 * Roles de usuário
 */
export const USER_ROLES = {
  ADMIN: 'admin',
  USER: 'user',
  VIEWER: 'viewer',
};

/**
 * Rotas da aplicação
 */
export const ROUTES = {
  LOGIN: '/login',
  DASHBOARD: '/dashboard',
  CLIENTS: '/clients',
  PRODUCTS: '/products',
  ORDERS: '/orders',
  USERS: '/users',
};

/**
 * Endpoints da API
 */
export const API_ENDPOINTS = {
  AUTH: {
    LOGIN: '/auth/login',
    LOGOUT: '/auth/logout',
    ME: '/auth/me',
  },
  CLIENTS: '/clients',
  PRODUCTS: '/products',
  ORDERS: '/orders',
  USERS: '/users',
  DASHBOARD: '/dashboard',
  REPORTS: '/reports',
};
