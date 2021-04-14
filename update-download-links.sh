#!/bin/bash

INDEX="index.lighttpd.html"
main_title=""
last_path=""


sed -e '/<body>/,$d' $INDEX > /var/www/html/$INDEX
cd /var/www/html
chown -R www-data.www-data linux tinycore vmware windows

echo '    <body>' >> $INDEX
for file in $(find . -type f | grep -v seduce_doc | sed 's/^.//' | sort); do
	path=$(echo ${file%/*})
	name=$(echo ${file##*/})
	if [ ! -z "$path" ]; then
		if [[ $path != $last_path ]];then
            if [ -n "$last_path" ]; then
			    echo "          </div><!-- sub-title -->" >> $INDEX
            fi
			# remove all chars except the slashes
			nb_slash=$(echo -n ${path//[^\/]} | wc -c)
			for i in $(seq 2 $(( $nb_slash + 1))); do
				title=$(echo $path | cut -d'/' -f$i)
				if [ $i -eq 2 ]; then
					if [[ $main_title != $title ]]; then
						if [ -n "$main_title" ]; then
							echo "      </div><!-- main-title -->" >> $INDEX
						fi
						main_title=$title
						echo "      <div class='main-title'>" >> $INDEX
						echo "        <div>$title</div>" >> $INDEX
					fi
				else
					echo "          <div class='sub-title'>" >> $INDEX
					echo "            <div>$title</div>" >> $INDEX
				fi
			done
			last_path=$path
		fi
		echo  "+ $name"
		relative_path=$(echo $file | sed 's/^.//')
        last_modified=$(stat -c'%y' $relative_path | cut -c 1-16)
        size=$(ls -lh $relative_path | cut -d' ' -f5)
        echo "              <a href='$relative_path'>$name</a><br/>" >> $INDEX
        echo "              <span>-- $size, last modified at $last_modified --</span><br/><br/>" >> $INDEX
	fi
done
echo "          </div><!-- sub-title -->" >> $INDEX
echo "      </div><!-- main-title -->" >> $INDEX
echo '    </body>' >> $INDEX
echo '</html>' >> $INDEX
