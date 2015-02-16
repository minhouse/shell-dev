#!/bin/bash

nc -i 2 localhost 25 <<EOT
HELO localhost
MAIL FROM: <root>
RCPT TO: <root>
DATA
FROM: <root>
To: <root>
Subject: testmail3

test mail3

.
quit

EOT


