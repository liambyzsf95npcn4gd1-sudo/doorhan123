FROM php:7.4-apache

# Install dependencies
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Enable mod_rewrite
RUN a2enmod rewrite

# Change DocumentRoot to /var/www/html/public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Set permissions
# Ensure www-data user owns the files
RUN chown -R www-data:www-data /var/www/html

# Create uploads directory and set permissions
RUN mkdir -p /var/www/html/public/uploads \
    && chmod -R 777 /var/www/html/public/uploads

# Expose port 80
EXPOSE 80

# Working directory
WORKDIR /var/www/html

# Copy application source
COPY . /var/www/html
