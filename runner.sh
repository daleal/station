# Move to mounted folder
cd base

# Get template
echo "Getting template files..."
git clone --branch stable https://github.com/daleal/station.git &> /dev/null
cd station

# Run python script
echo "Running generator script..."
python station.py "$@"

# Get project folder name
GENERATED=$(ls -t | head -1)

# Clean mounted directory
echo "Cleaning some stuff..."
mv "$GENERATED" "../$GENERATED"
cd ..
rm -rf station
