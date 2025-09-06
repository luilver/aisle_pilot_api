# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog and this project adheres to Semantic Versioning.

## [Unreleased]

### Added
- Store search by zip code endpoint: GET /api/v1/stores?zip_code=12345 (BACKND001)
- Optimized shopping order endpoint: GET /api/v1/shopping_lists/:id/optimized_order
- Request specs for new store zip code search functionality
- Request specs for optimized shopping order endpoint

### Changed
- Enhanced StoresController#index to support zip code filtering
- Implemented ShoppingListsController#optimized_order method

<!-- When releasing, move items above into a new section, e.g. `## [0.1.0] - YYYY-MM-DD` -->

## [1.1.1] - 2025-08-26

### Chores
- Fixed duplication issue in `inherit_gem` configuration in .rubocop.yml
- Fixed formatting errors detected by RuboCop:
  - Removed trailing whitespace in multiple files
  - Removed spaces inside array brackets
  - Added missing final newlines in files

## [1.1.0] - 2025-08-25

### Added
- Request specs for Shopping Lists (index, create, show, update, delete).
- Request spec for Shopping List Items destroy.
- Additional request specs for Products: show and filter by store_id.

### Changed
- Implemented `ProductsController#show` for GET /api/v1/products/:id.

## [0.1.0] - 2025-08-25

### Added
- Configure RuboCop with rubocop-rails-omakase base rules.

### Changed
- Centralized JWT handling in `ApplicationController` with ENV fallback for test/dev and consistent HS256.

### Fixed
- RSpec integration specs returning 401 due to JWT secret mismatch; aligned specs and test env.
- Minor RuboCop offenses in `ShoppingListsController`.

### Docs
- Introduced CHANGELOG following Keep a Changelog.

### Chores
- Ensure local environment uses Ruby 3.3.9 (see `.ruby-version`) and Bundler 2.5.22 per `Gemfile.lock`.
