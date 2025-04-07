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

    curl -s https://raw.githubusercontent.com/Dubrovsky18/test-case-effective-mobile/main/install_monitor-test.sh | sudo bash
    
#### Вариант 2

1. **Склонируйте репозиторий или создайте файлы вручную**:
   ```bash
   git clone https://github.com/yourusername/monitor-test.git
   cd monitor-test
###### Или скопируйте файлы: monitor_test.sh, monitor-test.service, monitor-test.timer.

2. **Разместите скрипт**:

    sudo cp monitor_test.sh /usr/local/bin/monitor_test.sh
    sudo chmod +x /usr/local/bin/monitor_test.sh

3. **Создайте лог-файл**:

    sudo touch /var/log/monitoring.log
    sudo chmod 644 /var/log/monitoring.log

4. **Настройте systemd-сервис**:

    sudo cp monitor-test.service /etc/systemd/system/monitor-test.service

5. **Настройте systemd-таймер**:

    sudo cp monitor-test.timer /etc/systemd/system/monitor-test.timer

6. **Перезагрузите systemd и запустите**:

    sudo systemctl daemon-reload
    sudo systemctl enable monitor-test.timer
    sudo systemctl start monitor-test.timer

7. **Проверьте статус**:

    sudo systemctl status monitor-test.timer
    sudo systemctl status monitor-test.service

Файлы в репозитории:

- intall_monitor-test.sh: Скрипт установки программы.
- monitor-test.sh: Основной скрипт мониторинга.
- monitor-test.service: Systemd-юнит для запуска скрипта.
- monitor-test.timer: Systemd-таймер для запуска каждую минуту.