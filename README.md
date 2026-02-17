# DoorHan International Multilingual Website

This project is a modern, responsive, and fully multilingual website for DoorHan International. It has been refactored to use a 100% database-driven architecture for content and translations, ensuring zero-configuration deployment.

## Key Features

*   **Database-Driven Translations:** All UI text, product content, categories, and settings are stored in the MySQL database. No hardcoded strings or language files.
*   **Dynamic Language Support:** Adding a new language is as simple as adding a record to the `languages` table. The UI automatically adapts.
*   **Zero-Configuration Deployment:** Using Docker and Docker Compose, the entire stack (Apache/PHP + MySQL) spins up with a single command.
*   **Chinese Language Support:** Native support for Simplified Chinese with correct font rendering ('Noto Sans SC').

## Prerequisites

*   Docker
*   Docker Compose

## Installation & Deployment (1-Click)

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    cd <repository_folder>
    ```

2.  **Deploy using the helper script:**
    ```bash
    ./deploy.sh
    ```

    *Alternatively, manually:*
    ```bash
    cp .env.example .env
    docker-compose down -v
    docker-compose up -d --build
    ```

3.  **Access the website:**
    *   **Frontend:** [http://localhost:6063](http://localhost:6063)
    *   **Admin Panel:** [http://localhost:6063/admin](http://localhost:6063/admin)

## Administration

*   **Admin Panel URL:** `/admin`
*   **Default Username:** `admin`
*   **Default Password:** `P@ssw0rd123!`

## Translation System Guide

The system uses a custom `Language` class (Singleton) that fetches translations from the `ui_translations` table.

*   **Adding a Language:** Insert a new row into the `languages` table (code, name, flag).
*   **Translating UI Elements:** Add rows to `ui_translations` table with the `language_id`, `key` (e.g., 'Home', 'Contact'), and the translated `value`.
*   **Content Translation:** Products, Categories, Pages, and Posts have corresponding translation tables (`product_translations`, etc.).

## Project Structure

*   `public/`: Web root. Contains `index.php` (entry point) and assets.
*   `core/`: Core classes (`Language.php`, `Database.php`, `Router.php`).
*   `controllers/`: MVC Controllers.
*   `models/`: Database Models.
*   `templates/`: HTML/PHP templates (Frontend and Admin).
*   `config/`: Configuration files (dynamic).
*   `database_init.sql`: Complete database schema and seed data.
