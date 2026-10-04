# Pokedex Flutter App

A small Flutter app that shows Pokemon from the public PokeAPI, with a
favorites feature that stays in sync across all screens and persists locally.

## Features
- Paginated Pokemon list with infinite scroll
- Search by name (filters the currently loaded list)
- Detail screen: artwork, types, height, weight, abilities, base stats
- Favorites tab with real-time updates
- Loading, error (with retry) and empty states

## How to run
1. Install Flutter and run `flutter doctor`
2. `flutter pub get`
3. `flutter run` (or `flutter run -d chrome`)

## Project structure
- `lib/models`: data classes and JSON parsing
- `lib/services`: API calls (no UI code)
- `lib/providers`: `FavoritesProvider` (state and storage)
- `lib/screens`: list, detail, favorites, home (bottom navigation)
- `lib/widgets`: reusable widgets (Pokemon card)

## State management: Provider + ChangeNotifier
Favorites live in a single `FavoritesProvider`, which is the one source of
truth. The list, detail and favorites screens all read from it, so toggling
a heart on any screen updates the others instantly with no manual refresh.
I chose Provider because it is simple, officially recommended, and enough
for an app of this size. Cards use `context.select` so only the affected
heart rebuilds.

## Local storage: shared_preferences
Favorites are a small set of id/name pairs, so a key-value store is enough.
shared_preferences needs almost no setup and works on mobile and web. The
provider saves on every toggle and loads on app start.

## Assumptions
- I implemented the layout from the assignment description with a reasonable
  design (cards, type-colored detail header, bottom navigation).
- Favorites store id and name so the Favorites tab can render without
  extra API calls.

## Known limitations / future improvements
- Search filters only the Pokemon loaded so far, not the whole Pokedex
- Design is close to the Figma reference but not pixel-perfect
- No offline caching of Pokemon data
- No unit or widget tests (out of scope for this task)