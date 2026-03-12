/**
 * Serviço de notificações do tipo toast
 * Pode ser expandido para usar bibliotecas como toast-ui, react-toastify, etc.
 */

class NotificationService {
  constructor() {
    this.listeners = [];
  }

  /**
   * Inscrever listener para notificações
   */
  subscribe(listener) {
    this.listeners.push(listener);
    return () => {
      this.listeners = this.listeners.filter(l => l !== listener);
    };
  }

  /**
   * Disparar notificação para todos os listeners
   */
  notify(notification) {
    const id = Date.now();
    const fullNotification = { ...notification, id };
    this.listeners.forEach(listener => listener(fullNotification));
    return id;
  }

  /**
   * Notificação de sucesso
   */
  success(message, duration = 3000) {
    return this.notify({
      type: 'success',
      message,
      duration,
    });
  }

  /**
   * Notificação de erro
   */
  error(message, duration = 5000) {
    return this.notify({
      type: 'error',
      message,
      duration,
    });
  }

  /**
   * Notificação de aviso
   */
  warning(message, duration = 4000) {
    return this.notify({
      type: 'warning',
      message,
      duration,
    });
  }

  /**
   * Notificação de informação
   */
  info(message, duration = 3000) {
    return this.notify({
      type: 'info',
      message,
      duration,
    });
  }

  /**
   * Notificação de carregamento
   */
  loading(message) {
    return this.notify({
      type: 'loading',
      message,
      duration: 0, // Sem auto-dismiss
    });
  }
}

export default new NotificationService();
