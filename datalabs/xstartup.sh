# Datalabs API was emitting state change before the VNC server was actually ready, 
# So we moved the websockify to xstartup, to ensure the VNC server is ready.
# Optimally we would use a VNC server with builtin socket support.
export HOME_OVERRRIDE=/media/$USER
source /init.sh
websockify $IF_main_port localhost:5900 &
openbox &
bash -c "sleep 3000"
