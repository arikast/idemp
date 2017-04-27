ssh your.server.ip.here '

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

idemp apt_get_update && sudo apt-get update 
idemp zip && sudo apt-get install -y unzip

### make a solr user
idemp solruser && useradd solruser
sudo mkdir -p /var/tools/solr
sudo chown solruser:solruser /var/tools/solr

cd /var/tools/solr
idemp solrdownload && {
    curl -O http://archive.apache.org/dist/lucene/solr/6.4.1/solr-6.4.1.zip 
    unzip solr-6.4.1.zip
    ln -s solr-6.4.1.zip solr
}
'

echo "done"
