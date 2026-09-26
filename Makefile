SHELL := /bin/bash
.DEFAULT_GOAL := help

PHP ?= php
COMPOSER ?= composer
NPM ?= npm
NODE ?= node
RSYNC ?= rsync

HOST ?= 127.0.0.1
PORT ?= 8010
DB_CONTAINER ?= shamim-mysql
FILTER ?=

ARTISAN := $(PHP) artisan
THEME_DIR := packages/BagistoPlus/ShamimPackVisual
THEME_BUILD_DIR := $(THEME_DIR)/public/themes/shop/shamim-pack
THEME_PUBLIC_DIR := public/themes/shop/shamim-pack
SHAMIM_VISUAL_DIR := packages/BagistoPlus/ShamimVisual
VELOCITY_DIR := packages/BagistoPlus/VisualVelocity
SHOP_DIR := packages/Webkul/Shop
ADMIN_DIR := packages/Webkul/Admin
FRONTEND_DIRS := $(THEME_DIR) $(SHAMIM_VISUAL_DIR) $(VELOCITY_DIR) $(SHOP_DIR) $(ADMIN_DIR)

.PHONY: help install build dev clear up db-start db-stop db-status npm-install npm-build npm-dev refresh rebuild theme-refresh theme-rebuild theme-fast theme-install theme-dev theme-build theme-sync theme-publish \
	frontend-install frontend-build frontend-dev shop-build shop-dev admin-build admin-dev visual-build velocity-build \
	serve cache-clear cache-build cache-refresh view-clear view-cache config-clear route-clear event-clear \
	composer-install composer-dump migrate migrate-status seed storage-link queue schedule tinker routes about logs \
	test test-shop test-admin pint pint-dirty pint-check translations-check catalog-images catalog-seed git-status doctor

up: ## Start the Shamim database, then run Laravel on HOST/PORT
	@$(MAKE) --no-print-directory db-start
	@$(MAKE) --no-print-directory serve

help: ## Show all available commands
	@printf "Shamim / Bagisto helper commands\n\n"
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z0-9_.-]+:.*## / {printf "  %-22s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@printf "\nExamples:\n"
	@printf "  make theme-refresh\n"
	@printf "  make theme-dev\n"
	@printf "  make serve PORT=8010\n"
	@printf "  make test FILTER=ProductTest\n"

refresh: theme-refresh ## Alias: fully rebuild and refresh the Shamim Pack theme

rebuild: theme-rebuild ## Alias: reinstall dependencies, then fully refresh the theme

install: composer-install theme-install ## Install PHP and Shamim Pack npm dependencies

build: theme-refresh ## Build and publish the active Shamim Pack theme

dev: theme-dev ## Alias: start Shamim Pack Vite watch/HMR

clear: cache-clear ## Alias: clear all Laravel caches

db-start: ## Start the Shamim MySQL Docker container
	docker start "$(DB_CONTAINER)"

db-stop: ## Stop the Shamim MySQL Docker container
	docker stop "$(DB_CONTAINER)"

db-status: ## Show the Shamim MySQL Docker container status
	docker ps -a --filter "name=$(DB_CONTAINER)" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"


npm-install: theme-install ## Alias: install Shamim Pack npm dependencies

npm-build: theme-build ## Alias: generate Shamim Pack production CSS/JS

npm-dev: theme-dev ## Alias: start Shamim Pack Vite watch/HMR

theme-refresh: ## Build CSS/JS, sync public assets, clear caches, and cache Blade views
	@$(MAKE) --no-print-directory theme-build
	@$(MAKE) --no-print-directory theme-sync
	@$(MAKE) --no-print-directory cache-clear
	@$(MAKE) --no-print-directory view-cache
	@printf "\nShamim Pack refreshed successfully.\n"

theme-rebuild: ## Clean npm install from lockfile, then run theme-refresh
	@$(MAKE) --no-print-directory theme-install
	@$(MAKE) --no-print-directory theme-refresh

theme-fast: ## Re-publish the existing build and refresh Laravel caches (no npm build)
	@$(MAKE) --no-print-directory theme-sync
	@$(MAKE) --no-print-directory cache-clear
	@$(MAKE) --no-print-directory view-cache

theme-install: ## Install Shamim Pack npm dependencies from package-lock.json
	cd "$(THEME_DIR)" && $(NPM) ci

theme-dev: ## Start Shamim Pack Vite in watch/HMR mode
	cd "$(THEME_DIR)" && $(NPM) run dev

theme-build: ## Generate production Shamim Pack CSS and JavaScript
	cd "$(THEME_DIR)" && $(NPM) run build

theme-sync: ## Mirror generated theme assets into public and remove stale hashed files
	@test -f "$(THEME_BUILD_DIR)/manifest.json" || { echo "Theme build is missing. Run: make theme-build"; exit 1; }
	@mkdir -p "$(THEME_PUBLIC_DIR)"
	$(RSYNC) -a --delete "$(THEME_BUILD_DIR)/" "$(THEME_PUBLIC_DIR)/"

theme-publish: ## Publish theme assets through Laravel (does not prune stale hashes)
	$(ARTISAN) vendor:publish --tag=shamim-pack-assets --force

frontend-install: ## Install npm dependencies for Shamim, Visual, Velocity, Shop, and Admin
	@set -e; for dir in $(FRONTEND_DIRS); do \
		echo "==> npm install: $$dir"; \
		if [ -f "$$dir/package-lock.json" ]; then (cd "$$dir" && $(NPM) ci); else (cd "$$dir" && $(NPM) install); fi; \
	done

frontend-build: ## Build Shamim, Visual, Velocity, Shop, and Admin frontend assets
	@set -e; for dir in $(FRONTEND_DIRS); do \
		echo "==> npm build: $$dir"; \
		(cd "$$dir" && $(NPM) run build); \
	done

frontend-dev: ## Start a package Vite server: make frontend-dev DIR=packages/Webkul/Shop
	@test -n "$(DIR)" || { echo "DIR is required. Example: make frontend-dev DIR=$(SHOP_DIR)"; exit 1; }
	cd "$(DIR)" && $(NPM) run dev

shop-build: ## Build the Bagisto Shop frontend
	cd "$(SHOP_DIR)" && $(NPM) run build

shop-dev: ## Start the Bagisto Shop Vite server
	cd "$(SHOP_DIR)" && $(NPM) run dev

admin-build: ## Build the Bagisto Admin frontend
	cd "$(ADMIN_DIR)" && $(NPM) run build

admin-dev: ## Start the Bagisto Admin Vite server
	cd "$(ADMIN_DIR)" && $(NPM) run dev

visual-build: ## Build the editable Shamim Visual package
	cd "$(SHAMIM_VISUAL_DIR)" && $(NPM) run build

velocity-build: ## Build the Visual Velocity package
	cd "$(VELOCITY_DIR)" && $(NPM) run build

serve: ## Run Laravel locally (HOST=127.0.0.1 PORT=8010)
	$(ARTISAN) serve --host="$(HOST)" --port="$(PORT)"

cache-clear: ## Clear config, route, view, event, app, and compiled caches
	$(ARTISAN) optimize:clear

cache-build: ## Build Laravel production caches
	$(ARTISAN) optimize

cache-refresh: ## Clear all caches and rebuild Blade view cache
	@$(MAKE) --no-print-directory cache-clear
	@$(MAKE) --no-print-directory view-cache

view-clear: ## Clear compiled Blade views
	$(ARTISAN) view:clear

view-cache: ## Compile and cache all Blade views
	$(ARTISAN) view:cache

config-clear: ## Clear Laravel configuration cache
	$(ARTISAN) config:clear

route-clear: ## Clear Laravel route cache
	$(ARTISAN) route:clear

event-clear: ## Clear Laravel event cache
	$(ARTISAN) event:clear

composer-install: ## Install PHP dependencies
	$(COMPOSER) install

composer-dump: ## Regenerate Composer autoload files and discover packages
	$(COMPOSER) dump-autoload

migrate: ## Run pending database migrations
	$(ARTISAN) migrate

migrate-status: ## Show database migration status
	$(ARTISAN) migrate:status

seed: ## Run database seeders
	$(ARTISAN) db:seed

catalog-images: ## Regenerate the 26 framed Persian dimension images (requires Google Chrome)
	$(NODE) scripts/render-catalog-images.mjs --force

catalog-seed: ## Import/update catalog products and rebuild product indexes
	$(ARTISAN) db:seed --class=ShamimPackagingCatalogSeeder
	$(ARTISAN) indexer:index
	$(ARTISAN) optimize:clear

storage-link: ## Create Laravel public storage symlink
	$(ARTISAN) storage:link

queue: ## Run the Laravel queue worker
	$(ARTISAN) queue:work

schedule: ## Run the Laravel scheduler worker
	$(ARTISAN) schedule:work

tinker: ## Open Laravel Tinker
	$(ARTISAN) tinker

routes: ## List application routes
	$(ARTISAN) route:list

about: ## Show Laravel environment and package information
	$(ARTISAN) about

logs: ## Follow the Laravel application log
	tail -n 150 -f storage/logs/laravel.log

test: ## Run tests; optionally use FILTER=TestName
	$(ARTISAN) test --compact $(if $(FILTER),--filter="$(FILTER)",)

test-shop: ## Run Shop package tests
	$(ARTISAN) test --compact packages/Webkul/Shop/tests $(if $(FILTER),--filter="$(FILTER)",)

test-admin: ## Run Admin package tests
	$(ARTISAN) test --compact packages/Webkul/Admin/tests $(if $(FILTER),--filter="$(FILTER)",)

pint: ## Format all PHP files with Laravel Pint
	vendor/bin/pint

pint-dirty: ## Format only changed PHP files
	vendor/bin/pint --dirty

pint-check: ## Check PHP formatting without changing files
	vendor/bin/pint --test

translations-check: ## Validate Bagisto translation keys
	$(ARTISAN) bagisto:translations:check

git-status: ## Show the short Git working-tree status
	git status --short

doctor: ## Show tool versions and Laravel environment details
	@$(PHP) --version | head -1
	@$(COMPOSER) --version
	@$(NPM) --version
	@$(MAKE) --version | head -1
	@$(ARTISAN) about
