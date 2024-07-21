docker run \
    --rm --entrypoint "" \
    -v `pwd`/opt/backup:/backup \
    --link="shvirtd_18-4-db-1" \
    --net shvirtd_18-4_backend \
    schnitzler/mysqldump \
    mysqldump --opt -h db -u root -pYtReWq4321 "--result-file=/backup/dumps.sql" database