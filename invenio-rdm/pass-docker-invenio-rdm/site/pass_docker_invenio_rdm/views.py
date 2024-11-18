"""Additional views."""

from flask import Blueprint

#
# Registration
#
def create_blueprint(app):
    """Register blueprint routes on app."""
    blueprint = Blueprint(
        "pass_docker_invenio_rdm",
        __name__,
        template_folder="./templates",
    )

    # Add URL rules
    return blueprint
