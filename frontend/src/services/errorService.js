import { MESSAGES, HTTP_STATUS } from '../constants';
import notificationService from './notificationService';

/**
 * Serviço centralizado para tratamento de erros
 */
class ErrorService {
  /**
   * Extrair mensagem de erro da resposta
   */
  getErrorMessage(error) {
    // Erro de resposta do servidor
    if (error.response) {
      const { status, data } = error.response;

      if (data?.message) return data.message;
      if (data?.error) return data.error;

      // Mensagens padrão por status
      switch (status) {
        case HTTP_STATUS.BAD_REQUEST:
          return MESSAGES.ERROR.FETCH_FAILED;
        case HTTP_STATUS.UNAUTHORIZED:
          return MESSAGES.ERROR.UNAUTHORIZED;
        case HTTP_STATUS.FORBIDDEN:
          return MESSAGES.ERROR.UNAUTHORIZED;
        case HTTP_STATUS.NOT_FOUND:
          return 'Recurso não encontrado.';
        case HTTP_STATUS.CONFLICT:
          return 'Conflito ao processar a operação.';
        case HTTP_STATUS.INTERNAL_ERROR:
          return 'Erro interno do servidor.';
        default:
          return MESSAGES.ERROR.UNKNOWN;
      }
    }

    // Erro de rede
    if (error.message === 'Network Error') {
      return MESSAGES.ERROR.NETWORK_ERROR;
    }

    // Erro genérico
    return error.message || MESSAGES.ERROR.UNKNOWN;
  }

  /**
   * Tratamento de erro com log e notificação
   */
  handle(error, operation = 'operação') {
    const message = this.getErrorMessage(error);

    console.error(`Erro durante ${operation}:`, {
      message,
      status: error.response?.status,
      data: error.response?.data,
      error: error.message,
    });

    return message;
  }

  /**
   * Tratamento de erro silencioso (apenas log)
   */
  silent(error, operation = 'operação') {
    console.error(`Erro durante ${operation}:`, error);
    return this.getErrorMessage(error);
  }

  /**
   * Validar se é erro de autenticação
   */
  isAuthError(error) {
    return error.response?.status === HTTP_STATUS.UNAUTHORIZED;
  }

  /**
   * Validar se é erro de validação
   */
  isValidationError(error) {
    return error.response?.status === HTTP_STATUS.BAD_REQUEST;
  }

  /**
   * Extrair erros de validação
   */
  getValidationErrors(error) {
    if (!this.isValidationError(error)) return null;

    const data = error.response?.data;

    // Se for um array de erros
    if (Array.isArray(data?.errors)) {
      return data.errors.reduce((acc, err) => {
        acc[err.field] = err.message;
        return acc;
      }, {});
    }

    // Se for objeto de erros
    if (typeof data?.errors === 'object') {
      return data.errors;
    }

    return null;
  }
}

export default new ErrorService();
