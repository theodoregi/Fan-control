FC_PATH=
TEST_PATH=$(find $FC_PATH -name fan_control.sh)
if [ -z "$TEST_PATH" ] && [ ! -z "$FC_PATH" ]; then
    echo "Not a correct fan_control path given."
    exit 1;
else
    echo "fan_control path is : $FC_PATH"
fi

chmod +x "$FC_PATH/fan_control.sh" "$FC_PATH/monitoring_fan.sh" "$FC_PATH/stop_fan.sh"

if systemctl list-unit-files | grep -qw fan_control.service; then
    echo "fan_control service exists. Attempting to stop..."
    sudo systemctl stop fan_control.service
    sudo systemctl disable fan_control.service
    echo "fan_control service stopped."
else
    echo "fan_control service does not exist."
fi

sudo echo > /etc/systemd/system/fan_control.service

echo "[Unit]" | sudo tee /etc/systemd/system/fan_control.service > /dev/null
echo "Description=Starts fan control." | sudo tee -a /etc/systemd/system/fan_control.service > /dev/null
echo "" | sudo tee -a /etc/systemd/system/fan_control.service > /dev/null
echo "[Service]" | sudo tee -a /etc/systemd/system/fan_control.service > /dev/null
echo "ExecStart="$FC_PATH"/fan_control.sh" | sudo tee -a /etc/systemd/system/fan_control.service > /dev/null
echo "" | sudo tee -a /etc/systemd/system/fan_control.service > /dev/null
echo "[Install]" | sudo tee -a /etc/systemd/system/fan_control.service > /dev/null
echo "WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/fan_control.service > /dev/null

echo ""
cat /etc/systemd/system/fan_control.service
echo ""

sudo systemctl daemon-reload
sudo systemctl enable fan_control.service
sudo systemctl start fan_control.service
sudo systemctl status fan_control.service
