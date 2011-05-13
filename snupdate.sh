#!/bin/bash
# Prompt for statusnet version number
echo "What build of StatusNet would you like to install? (ie. 0.9.7)"
read NEW_BUILD
echo "What build of StatusNet is currently installed? (ie. 0.9.6)"
read OLD_BUILD
# Download new tarball to server
echo "Downloading StatusNet build" $NEW_BUILD"..."
sudo wget http://status.net/statusnet-$NEW_BUILD.tar.gz
wait
echo "...Done"
# Unpack tarball into www root
echo "Unpacking tarball..."
sudo tar zxf statusnet-$NEW_BUILD.tar.gz
wait
echo "...Done"
# Remove tarball
echo "Removing tarball..."
sudo rm statusnet-$NEW_BUILD.tar.gz
wait
echo "...Done"
# Copy over essential files and folders
echo "Copying custom files over from previous instance..."
sudo cp /var/www/mublog/config.php /var/www/statusnet-$NEW_BUILD/
sudo cp /var/www/mublog/apple-touch-icon.png /var/www/statusnet-$NEW_BUILD/
sudo cp /var/www/mublog/favicon.ico /var/www/statusnet-$NEW_BUILD/
sudo cp -R /var/www/mublog/avatar /var/www/statusnet-$NEW_BUILD/
sudo cp -R /var/www/mublog/file /var/www/statusnet-$NEW_BUILD/
sudo cp -R /var/www/mublog/background /var/www/statusnet-$NEW_BUILD/
echo "...Done"
# Give proper access to public folders
echo "Giving proper permissions to public folders..."
sudo chmod -R a+w /var/www/statusnet-$NEW_BUILD/avatar
sudo chmod -R a+w /var/www/statusnet-$NEW_BUILD/file
sudo chmod -R a+w /var/www/statusnet-$NEW_BUILD/background
sudo cp -R /var/www/mublog/theme/default /var/www/statusnet-$NEW_BUILD/theme/
echo "...Done"
# Stop the daemons
echo "Stopping daemons from previous instance..."
sudo /var/www/mublog/scripts/stopdaemons.sh
wait
echo "...Done"
# Rename current mublog to old
echo "Renaming old instance to statusnet-"$NEW_BUILD"..."
sudo mv /var/www/mublog /var/www/mublog-$OLD_BUILD
wait
echo "...Done"
# Rename new build to mublog
echo "Renaming new instance to mublog..."
sudo mv /var/www/statusnet-$NEW_BUILD /var/www/mublog
wait
echo "...Done"
# Rename htaccess.sample and set rewrite base
echo "Setting up new htaccess file..."
sudo cp /var/www/mublog/htaccess.sample /var/www/mublog/.htaccess
wait
sudo sed -i 's,RewriteBase /mublog/,RewriteBase /,g' /var/www/mublog/.htaccess
wait
echo "...Done"
# Start daemons
echo "Releasing the daemons for new instance..."
sudo /var/www/mublog/scripts/startdaemons.sh
echo "...Done"
# Upgrade completion message
echo "StatusNet has been upgraded from "$OLD_BUILD" to "$NEW_BUILD" successfully!"
