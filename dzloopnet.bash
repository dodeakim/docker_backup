#!/usr/bin/env bash


# XAUTH=/tmp/.docker.xauth
# if [ ! -f $XAUTH ]
# then
#     xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
#     if [ ! -z "$xauth_list" ]
#     then
#         echo $xauth_list | xauth -f $XAUTH nmerge -
#     else
#         touch $XAUTH
#     fi
#     chmod a+r $XAUTH
# fi

sudo rm -rf /tmp/.docker.xauth
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

export LIBGL_ALWAYS_SOFTWARE=1
export XDG_RUNTIME_DIR=/tmp/runtime-root

xhost + local:docker

docker run --rm -it \
    --privileged \
    --workdir="/root/" \
    --runtime=nvidia \
    --gpus "all"\
    --ipc "host" \
    --env DISPLAY=unix$DISPLAY \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/media/masl/T7 Shield/Dataset:/root" \
    --volume="/home/masl/kdy/python:/root/dzloop" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --network="host" \
    --name dzloop_setup \
    dzloop:0423  \
    bash
