FROM alpine:3.14

RUN apk add curl bash git
RUN curl -s https://fluxcd.io/install.sh | bash
RUN cd /bin && curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

COPY create-tenant.sh /create-tenant.sh
COPY .default-gitconfig /root/.gitconfig
RUN chmod +x /create-tenant.sh

CMD [ "/bin/bash", "-c", "/create-tenant.sh" ]