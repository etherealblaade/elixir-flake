# 🧪 Elixir Phoenix LiveView Development Flake

[![Nix Flake](https://img.shields.io/badge/Nix-Flake-blue.svg)](https://nixos.wiki/wiki/Flakes)
[![Elixir](https://img.shields.io/badge/Elixir-1.14+-purple.svg)](https://elixir-lang.org/)
[![Phoenix](https://img.shields.io/badge/Phoenix-1.7+-orange.svg)](https://www.phoenixframework.org/)
[![Erlang/OTP](https://img.shields.io/badge/Erlang%2FOTP-26-red.svg)](https://www.erlang.org/)

Этот Nix флейк предоставляет полноценное окружение разработки для Elixir, Phoenix и LiveView с поддержкой macOS и Linux. Он включает в себя все необходимые инструменты и зависимости, а также кастомно собранный ElixirLS для улучшенной поддержки IDE.

## ✨ Особенности

- 🧬 Elixir и Erlang OTP 26
- 🔥 Phoenix Framework с поддержкой LiveView
- 🛠 Кастомно собранный ElixirLS для улучшенной поддержки IDE
- 🐘 PostgreSQL
- 🟩 Node.js для фронтенд-разработки
- 🔄 Поддержка direnv для автоматической активации окружения
- 🍎 Поддержка macOS и Linux
- 🔍 Инструменты для отслеживания изменений файловой системы (fswatch на macOS, inotify-tools на Linux)

## 🚀 Быстрый старт

1. Убедитесь, что у вас установлен [Nix](https://nixos.org/download.html) с поддержкой флейков.

2. Клонируйте этот репозиторий или скопируйте `flake.nix` в корень вашего проекта.

3. Создайте файл `.envrc` в корне вашего проекта со следующим содержимым:
   ```
   use flake
   ```

4. Разрешите использование direnv:
   ```bash
   direnv allow
   ```

5. Войдите в директорию проекта. Окружение разработки будет автоматически активировано.

## 🛠 Использование

После активации окружения у вас будет доступ к следующим инструментам:

- `elixir`, `iex`: Интерактивная оболочка Elixir
- `mix`: Инструмент сборки для Elixir
- `phoenix.new`: Генератор новых проектов Phoenix
- `postgres`: PostgreSQL сервер и клиент
- `node`, `npm`: Node.js и npm для фронтенд-разработки
- `elixir-ls`: Языковой сервер Elixir для поддержки IDE

## 🔧 Настройка IDE

Для использования ElixirLS в вашей IDE (например, VSCode, Vim, Emacs), настройте путь к исполняемому файлу `elixir-ls`, который теперь доступен в вашем PATH.

Для Helix, добавьте следующее в ваш `languages.toml`:

```toml
[[language]]
name = "elixir"
language-server = { command = "elixir-ls" }
```

## 🆘 Решение проблем

Если у вас возникли проблемы:

1. Убедитесь, что у вас установлена последняя версия Nix.
2. Попробуйте обновить флейк: `nix flake update`
3. Пересоздайте окружение: `nix develop --recreate-lock-file`

## 🤝 Вклад в проект

Мы приветствуем вклад в развитие этого флейка! Если у вас есть идеи по улучшению или вы нашли ошибку, пожалуйста, создайте issue или отправьте pull request.

## 📜 Лицензия

Этот проект распространяется под лицензией MIT. Подробности смотрите в файле LICENSE.

---

Создано с ♥️ для сообщества Elixir. Счастливого кодинга! 🎉
