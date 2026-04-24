# PROJECT_CONTEXT.md — DoorHan International Site

**Версия:** 1.0.0
**Дата:** 2026-04-24
**Архитектура:** Custom PHP MVC

---

## Точка входа

```
public/index.php
├── define('ROOT_PATH', dirname(__DIR__))
├── require config/config.php
├── session_start()
├── spl_autoload_register (core/, controllers/, models/)
├── Language::init()
├── $router->add() — регистрация маршрутов
└── $router->dispatch($uri)
```

**Web Root:** `public/` (не `/`, а `/public`)

---

## Роутинг

**Файл:** `core/Router.php`

Маршруты регистрируются в `public/index.php:57-95`:
```php
$router->add('/products/{slug}', 'PublicController', 'product');
```

Роутер:
- Преобразует `{param}` в regex `(?P<param>[^/]+)`
- Создает `$controller = new $controller()`
- Вызывает `$controller->$method($args, $uri)`

**Контроллеры:**
- `PublicController` — публичная часть (12 методов)
- `AdminController` — админка (24 метода)

---

## Структура БД (18 таблиц)

| Таблица | Назначение |
|---------|------------|
| `products` | Товары (без переводов) |
| `product_translations` | Переводы товаров (i18n) |
| `product_images` | Изображения товаров |
| `product_categories` | Связь товар-категория |
| `categories` | Категории (без переводов) |
| `category_translations` | Переводы категорий |
| `posts` | Новости/блог |
| `post_translations` | Переводы новостей |
| `pages` | Статические страницы |
| `page_translations` | Переводы страниц |
| `messages` | Сообщения из контактной формы |
| `settings` | Ключ-значение настроек |
| `users` | Пользователи админки |
| `navigation_items` | Меню навигации |
| `languages` | Список языков (14 языков) |
| `ui_translations` | Переводы UI-строк |
| `faqs` | FAQ вопросы |
| `faq_translations` | Переводы FAQ |

**Дамп:** `docker/init.sql`

---

## Зависимости

- PHP 7.4+ / 8.x
- MySQL 5.7+ / 8.0
- PDO MySQL extension
- Tailwind CSS (CDN)
- Alpine.js (CDN)
- Swiper.js (CDN)
- Google Fonts: Inter, Noto Sans SC

---

## Известные проблемы (на момент аудита)

| ID | Описание | Серьёзность |
|----|----------|-------------|
| GH-01 | Отсутствует шаблон `templates/public/404.php` | Высокая |
| GH-02 | `SUPPORTED_LANGUAGES` не определена в AdminController | Критическая |
| GH-03 | Папка `uploads/` не существует в репозитории | Средняя |
| GH-04 | Тёмный дизайн (требует редизайн) | Низкая |

---

## Правило модификации

Перед изменением любого файла:
1. Прочитать `PROJECT_CONTEXT.md`
2. Проверить связанные зависимости
3. Зафиксировать изменения через `git add . && git commit -m "description"`

---

## Конфигурация окружения (XAMPP)

```
DB_HOST=127.0.0.1
DB_USER=root
DB_PASS=
DB_NAME=doorhan
SITE_URL=http://localhost:8080
```

---

## Структура папок проекта

```
code-doorhan123/
├── config/          # Конфигурация
├── controllers/     # MVC контроллеры
├── core/            # Ядро (Database, Router, Flash, Language)
├── docker/          # Dockerfile, init.sql
├── models/          # MVC модели (8 штук)
├── public/          # Web root
│   ├── assets/      # CSS, JS, изображения
│   ├── uploads/     # Загруженные файлы (НЕ в репо)
│   └── index.php    # Точка входа
├── templates/       # Views
│   ├── admin/       # Админка
│   └── public/      # Публичная часть
├── tests/           # Тесты
└── docker-compose.yml
```