# Protocol Zero (Sovereign Starter Kit)

A reproducible, offline-first foundation for building sovereign systems.

## The Architecture
- **Core (Backend):** Elixir + Plug/Cowboy (Port 4000)
- **UI (Frontend):** Svelte 5 + TypeScript + Vite (Port 5173)
- **Database:** SurrealDB (Embedded/Local)
- **Contract:** Google Protobufs (Binary Transport)
- **Ops:** Nix Flakes + Direnv + Just

## ⚡ Quick Start

1. **Initialize Environment** (One-time per machine)
```bash
direnv allow
```

2. **Hydrate & Run Core**
```bash
cd core
just setup   # Installs deps & compiler plugins
just proto   # Generates Elixir structs from .proto
just dev     # Starts Server (:4000)
```

3. **Hydrate & Run UI**
```bash
cd ui
just setup   # Installs Node modules
just proto   # Generates TypeScript definitions from .proto
just dev     # Starts Frontend (:5173)
```

4. **Start Database**
```bash
cd core
just db      # Starts SurrealDB on :8000
```

## 🛠 Workflow

- **Renaming the Project:**
  Run `./scripts/rename_project.sh <new_snake_case_name>` to convert Protocol Zero into your new app.

- **Modifying the API:**
  1. Edit `core/priv/proto/base.proto`
  2. Run `just proto` in `core/`
  3. Run `just proto` in `ui/`
  4. Implement logic in `core/lib/scaffold/router.ex`

## 💾 Database Access
Use the built-in Repo module in Elixir:
```elixir
ProtocolZero.Repo.sql("CREATE user:chad SET age = 46")
```
