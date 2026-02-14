
# Protocol Zero (Sovereign Starter Kit)

A reproducible, offline-first foundation for building sovereign systems.

## The Architecture
- **Core (Backend):** Elixir + Plug/Cowboy (Port 4000)
- **UI (Frontend):** Svelte 5 + TypeScript + Vite (Port 5173)
- **Database:** SurrealDB (Embedded/Local)
- **Ops:** Nix Flakes + Direnv + Just

## ⚡ How to Start a New Project

1. **Clone the Template**
    ```bash
    git clone git@github.com:ChadCapra/protocol-zero.git my_new_project
    cd my_new_project
    ```

2. **Bootstrap (Rename & Reset)**
    This script renames the code and resets the Git history for you.
    ```bash
    ./scripts/bootstrap.sh my_new_project
    ```

3. **Ignite Engines**
    The root folder is just a container. You must enable the tools in each subfolder.

    **Backend:**
    ```bash
    cd core
    direnv allow
    just setup && just proto && just dev
    ```

    **Frontend:**
    ```bash
    cd ui
    direnv allow
    just setup && just proto && just dev
    ```

## 🛠 Workflow

- **Database:** Run `just db` inside `core/`.
- **Contracts:** Edit `core/priv/proto/base.proto` and run `just proto` in both folders.
