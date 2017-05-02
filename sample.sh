#### example showing how the idempotency script can be used
#### this script can be repeatedly run without ill effects on the destination server

#### set your env vars, this can of course be externalized
TOOLSDIR=/var/tools
SOLRUSER=solruser


#### setup the box in a giant ssh statement
ssh your.server.ip.here '

##### the core idemp function 
function idemp() {
    DEMPODIR="$HOME/.idemp"
    mkdir -p $DEMPODIR
    FLAG="$DEMPODIR/$1"

    if [ ! -f "$FLAG" ]; then
        touch "$FLAG"
        return 0
    else
        return 1
    fi
}

##### your code goes below here

idemp apt_get_update && sudo apt-get update 
idemp zip && sudo apt-get install -y unzip

### make a solr user
idemp solruser && sudo useradd solruser

### install solr
idemp solrdownload && {
    sudo mkdir -p '$TOOLSDIR'/solr
    sudo chown '$SOLRUSER':'$SOLRUSER' '$TOOLSDIR'/solr
    cd '$TOOLSDIR'/solr

    sudo -u '$SOLRUSER' -- curl -O http://archive.apache.org/dist/lucene/solr/6.4.1/solr-6.4.1.zip 
    sudo -u '$SOLRUSER' -- unzip solr-6.4.1.zip
    sudo -u '$SOLRUSER' -- ln -s solr-6.4.1.zip solr
    cd -
}
'

echo "done"
