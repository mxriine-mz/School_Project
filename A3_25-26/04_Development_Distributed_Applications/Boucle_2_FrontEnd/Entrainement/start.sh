#!/usr/bin/env bash
# Lance les 3 services ensemble : MongoDB local + API + frontend.
# Usage :  ./start.sh        (depuis le dossier Entrainement)
# Ctrl+C arrete proprement les trois.

set -euo pipefail
cd "$(dirname "$0")"

# Arrete tous les sous-processus quand on quitte (Ctrl+C inclus)
cleanup() { echo; echo "Arret des services…"; kill 0 2>/dev/null || true; }
trap cleanup EXIT INT TERM

echo "🍃 Demarrage de MongoDB local…"
( cd backend && node src/dev-db.js ) &

# Attend que MongoDB ecoute sur le port 27017 (max ~30s)
for i in $(seq 1 30); do
  if (exec 3<>/dev/tcp/127.0.0.1/27017) 2>/dev/null; then
    exec 3>&- 3<&-
    echo "🍃 MongoDB pret."
    break
  fi
  sleep 1
done

# Insere les 3 fruits de demo si la base est vide
COUNT=$(cd backend && node -e '
import("mongoose").then(async (m) => {
  await m.default.connect("mongodb://127.0.0.1:27017/crud_demo");
  const n = await m.default.connection.db.collection("fruits").countDocuments();
  console.log(n); await m.default.connection.close();
}).catch(() => console.log("0"));
')
if [ "${COUNT:-0}" = "0" ]; then
  echo "🌱 Base vide : insertion des fruits de demo…"
  ( cd backend && npm run --silent seed ) || true
fi

echo "🚀 Demarrage de l'API…"
( cd backend && npm start ) &

echo "⚡ Demarrage du frontend…"
( cd frontend && npm run dev ) &

echo
echo "✅ Tout est lance. Ouvre http://localhost:5173  (Ctrl+C pour tout arreter)"
wait
