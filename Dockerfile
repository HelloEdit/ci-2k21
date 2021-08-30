FROM golang as golang
WORKDIR /
RUN git clone https://github.com/gohugoio/hugo.git
WORKDIR /hugo
RUN go get . && go build -o hugo


FROM node AS node
COPY --from=golang /hugo/hugo /usr/bin
COPY . /src
WORKDIR /src
RUN npm install . && npm install . --only=dev && hugo mod get -u .
RUN hugo


FROM httpd
COPY --from=node /src/public /usr/local/apache2/htdocs/
