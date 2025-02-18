#!/usr/bin/env bash
#
# q4_script.sh - Creates a venv OUTSIDE the repo, activates it, returns to repo, then processes CSV & runs Python code.
#
# Usage: ./q4_script.sh [path_to_csv]
#        If [path_to_csv] is not provided, it defaults to "plants_data.csv" in the repo.
#


LOGFILE="q4_script.log"
touch "$LOGFILE"

echo "[INFO] Starting script at $(date)" | tee -a "$LOGFILE"

# 1) Capture the current repository directory and the CSV file name
REPO_DIR="$(pwd)"  
CSV_FILE="${1:-plants_data.csv}"
echo "[INFO] The repo directory is: $REPO_DIR" | tee -a "$LOGFILE"

# 2) Define an external venv path (outside the repo). For example, in $HOME
VENV_DIR="$HOME/Q4_ENV"

# 3) Create or reuse that venv
if [[ ! -d "$VENV_DIR" ]]; then
  echo "[INFO] Creating venv at $VENV_DIR (outside the repo)..." | tee -a "$LOGFILE"
  python3 -m venv "$VENV_DIR"
else
  echo "[INFO] Venv already exists at $VENV_DIR" | tee -a "$LOGFILE"
fi

# 4) Activate the venv
echo "[INFO] Activating venv in $VENV_DIR" | tee -a "$LOGFILE"
# shellcheck source=/dev/null
source "$VENV_DIR/bin/activate"

# 5) Return to the repo directory
cd "$REPO_DIR"

# 6) Validate CSV file existence
if [[ ! -f "$CSV_FILE" ]]; then
  echo "[ERROR] CSV file '$CSV_FILE' not found in repo directory!" | tee -a "$LOGFILE"
  exit 1
fi

# 7) Install needed Python packages (if not already present)
echo "[INFO] Installing / upgrading pip and matplotlib..." | tee -a "$LOGFILE"
pip install --upgrade pip >> "$LOGFILE" 2>&1
pip install matplotlib >> "$LOGFILE" 2>&1

# 8) Check if plant_2.py is executable. If not, make it so.
if [[ ! -x "plant_2.py" ]]; then
  echo "[INFO] Making plant_2.py executable..." | tee -a "$LOGFILE"
  chmod +x plant_2.py
fi

# 9) Read CSV line by line, skipping header
FIRST_LINE=1
while IFS=',' read -r PLANT HEIGHT LEAFCOUNT DRYWEIGHT; do
  # skip header row
  if [[ $FIRST_LINE -eq 1 ]]; then
    FIRST_LINE=0
    continue
  fi

  # Remove quotes if any
  CLEAN_PLANT=$(echo "$PLANT" | tr -d '"')
  CLEAN_HEIGHT=$(echo "$HEIGHT" | tr -d '"')
  CLEAN_LEAFCOUNT=$(echo "$LEAFCOUNT" | tr -d '"')
  CLEAN_DRYWEIGHT=$(echo "$DRYWEIGHT" | tr -d '"')

  echo "[INFO] Processing plant: $CLEAN_PLANT" | tee -a "$LOGFILE"
  echo "       Height: $CLEAN_HEIGHT" | tee -a "$LOGFILE"
  echo "       LeafCount: $CLEAN_LEAFCOUNT" | tee -a "$LOGFILE"
  echo "       DryWeight: $CLEAN_DRYWEIGHT" | tee -a "$LOGFILE"

  # Run the Python script
  if ! ./plant_2.py --plant "$CLEAN_PLANT" \
                  --height $CLEAN_HEIGHT \
                  --leaf_count $CLEAN_LEAFCOUNT \
                  --dry_weight $CLEAN_DRYWEIGHT \
                  >> "$LOGFILE" 2>&1
  then
    echo "[ERROR] Python script failed for $CLEAN_PLANT. See $LOGFILE for details." | tee -a "$LOGFILE"
    # decide if you want to exit 1 or continue to the next plant
    continue
  fi

  # Create a directory for this plant_2 if it doesn't exist
  if [[ ! -d "$CLEAN_PLANT" ]]; then
    mkdir "$CLEAN_PLANT"
    echo "[INFO] Created directory: $CLEAN_PLANT" | tee -a "$LOGFILE"
  fi

  # Move the PNG files
  mv "${CLEAN_PLANT}"_*.png "$CLEAN_PLANT"/ 2>>"$LOGFILE" || true

  echo "[INFO] Finished $CLEAN_PLANT" | tee -a "$LOGFILE"
  echo "--------------------------------------" | tee -a "$LOGFILE"

done < "$CSV_FILE"

# 10) Deactivate the venv
deactivate
echo "[INFO] Script completed at $(date)" | tee -a "$LOGFILE"
