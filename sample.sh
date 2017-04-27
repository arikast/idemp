#### example showing how the idempotency script can be used

ssh your.server.ip.here '

##### copy paste the core function here
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
    sudo mkdir -p /var/tools/solr
    sudo chown solruser:solruser /var/tools/solr
    cd /var/tools/solr

    sudo -u solruser -- curl -O http://archive.apache.org/dist/lucene/solr/6.4.1/solr-6.4.1.zip 
    sudo -u solruser -- unzip solr-6.4.1.zip
    sudo -u solruser -- ln -s solr-6.4.1.zip solr
    cd -
}
'

echo "done"
