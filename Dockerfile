FROM debian:bookworm-slim

LABEL repository="https://github.com/alexnorell/tofu-pr-commenter" \
    homepage="https://github.com/alexnorell/tofu-pr-commenter" \
    maintainer="Alex Norell" \
    com.github.actions.name="Tofu PR Commenter" \
    com.github.actions.description="Adds opinionated comments to a PR from Tofu fmt/init/plan output" \
    com.github.actions.icon="git-pull-request" \
    com.github.actions.color="yellow"

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    bash \
    ca-certificates

RUN curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh && \
    chmod +x install-opentofu.sh && \
    ./install-opentofu.sh --install-method deb && \
    rm -f install-opentofu.sh

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
