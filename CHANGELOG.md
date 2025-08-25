# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog and this project adheres to Semantic Versioning.

## [Unreleased]

### Added
- Additional request specs (pending) as new endpoints are implemented.

### Chores
- TBD

<!-- When releasing, move items above into a new section, e.g. `## [0.1.0] - YYYY-MM-DD` -->

## [0.1.1] - 2025-08-25

### Added
- Request specs para Shopping Lists (index, create, show, update, delete).
- Request spec para Shopping List Items destroy.
- Request specs extra para Products: show y filtro por store_id.

### Changed
- Implementado `ProductsController#show` para GET /api/v1/products/:id.

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
