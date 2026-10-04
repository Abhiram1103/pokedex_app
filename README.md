# Pokédex Flutter App

A Flutter Pokédex app built as a take-home assignment for Aptcoders.

The app uses the PokéAPI to display Pokémon, supports pagination and search,
provides detailed Pokémon information, and allows users to manage persistent
local favorites.

## Features

- Browse Pokémon from PokéAPI
- Paginated loading using the API's `next` URL
- Search currently loaded Pokémon by name or ID
- Pokémon detail screen
- Official Pokémon artwork
- Pokémon types with type-specific colors
- Height and weight information
- Abilities
- Base stats with progress indicators
- Add/remove favorites from the list and detail screens
- Dedicated Favorites screen
- Favorites synchronized across screens
- Favorites persisted locally between app launches
- Loading, error, and empty states
- Portrait-only orientation

## Tech Stack

- Flutter
- Dart
- Provider
- HTTP
- Shared Preferences
- PokéAPI

## Architecture

The project is organized into models, services, providers, screens,
and reusable widgets.

```text
lib/
├── main.dart
├── models/
│   ├── pokemon.dart
│   └── pokemon_detail.dart
├── providers/
│   ├── favorites_provider.dart
│   └── pokemon_provider.dart
├── screens/
│   ├── favorites_screen.dart
│   └── pokemon_detail_screen.dart
├── services/
│   └── pokemon_api.dart
├── theme/
│   └── app_theme.dart
└── widgets/
    ├── pokemon_card.dart
    └── pokemon_search_bar.dart
