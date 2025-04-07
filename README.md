# Test Case Effective Mobile

# Monitor Test Process

Этот проект содержит Bash-скрипт и systemd-юниты для мониторинга процесса `test` в среде Linux. Скрипт автоматически отслеживает состояние процесса и уведомляет о перезапусках или проблемах с сервером мониторинга через лог-файл.

## Что делает скрипт?

Скрипт `monitor_test.sh` выполняет следующие задачи:
1. **Проверка процесса**: Каждую минуту проверяет, запущен ли процесс с именем `test` (или частью имени).
2. **Отслеживание перезапуска**: Если процесс перезапустился (PID изменился), записывает информацию в лог `/var/log/monitoring.log`.
3. **Запрос к серверу**: Если процесс активен, отправляет HTTPS-запрос на `https://test.com/monitoring/test/api` для проверки доступности сервера.
4. **Логирование ошибок**: Если сервер мониторинга недоступен, добавляет запись в лог.
5. **Автозапуск**: Работает как systemd-сервис и запускается при старте системы с интервалом в 1 минуту.

Пример записей в логе:

    2025-04-07 12:00:01 - Process 'test' restarted. Previous PID: 1234, New PID: 5678
    2025-04-07 12:01:01 - Monitoring server https://test.com/monitoring/test/api is unavailable

## Как установить?

### Требования
- ОС: Linux с установленным `systemd`.
- Утилиты: `bash`, `curl`, `pgrep`.
- Права: Доступ с правами `root` для настройки systemd и логов.

### Шаги установки

#### Вариант 1
Через curl запустите файл установки программы

    curl -s https://raw.githubusercontent.com/Dubrovsky18/test-case-effective-mobile/refs/heads/main/install_monitor_test.sh | sudo bash

#### Вариант 2

1. **Склонируйте репозиторий или создайте файлы вручную**:
   ```bash
    git clone https://github.com/Dubrovsky18/test-case-effective-mobile.git
    ```
###### Или скопируйте файлы: monitor_test.sh, monitor-test.service, monitor-test.timer.

2. **Разместите скрипт**:
    ```bash
    sudo cp monitor_test.sh /usr/local/bin/monitor_test.sh
    sudo chmod +x /usr/local/bin/monitor_test.sh
    ```
3. **Создайте лог-файл**:
    ``` bash
    sudo touch /var/log/monitoring.log
    sudo chmod 644 /var/log/monitoring.log
    ```

4. **Настройте systemd-сервис**:
    ```bash
    sudo cp monitor-test.service /etc/systemd/system/monitor-test.service
    ```
5. **Настройте systemd-таймер**:
    ```bash
    sudo cp monitor-test.timer /etc/systemd/system/monitor-test.timer
    ```
6. **Перезагрузите systemd и запустите**:
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl enable monitor-test.timer
    sudo systemctl start monitor-test.timer
    ```
7. **Проверьте статус**:
    ```bash
    sudo systemctl status monitor-test.timer
    sudo systemctl status monitor-test.service
    ```
Файлы в репозитории
- install_monitor_test.sh: Скрипт для автоматической установки.
- monitor_test.sh: Основной скрипт мониторинга процесса test.
- monitor-test.service: Systemd-юнит для запуска скрипта.
- monitor-test.timer: Systemd-таймер для выполнения скрипта каждую минуту.
- check_test_case.sh: Тестовый скрипт для запуска процесса test и проверки работы мониторинга.