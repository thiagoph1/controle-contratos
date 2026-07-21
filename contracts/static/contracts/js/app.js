(() => {
  const button = document.querySelector('[data-menu-button]');
  const sidebar = document.querySelector('[data-sidebar]');
  if (button && sidebar) {
    button.addEventListener('click', () => sidebar.classList.toggle('open'));
  }
  document.querySelectorAll('.message').forEach((message) => {
    window.setTimeout(() => message.classList.add('fade'), 7000);
  });
})();
