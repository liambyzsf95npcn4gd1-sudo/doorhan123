FROM php:8.2-apache

# Install extensions
RUN docker-php-ext-install pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy custom Apache config
COPY docker/apache.conf /etc/apache2/sites-available/000-default.conf

# Copy application source
COPY . /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Fix permissions for uploads and other directories
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && mkdir -p /var/www/html/public/uploads \
    && chown -R www-data:www-data /var/www/html/public/uploads

# Expose port 80
EXPOSE 80
