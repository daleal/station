"""Main generator module."""

import argparse

import cookiecutter.main


def generate_parser():
    """Generates the parser for the module and returns it."""
    # Create parser
    parser = argparse.ArgumentParser(
        description="Rails template project generator."
    )

    # Project name
    parser.add_argument(
        "-n", "--project-name",
        dest="project_name",
        default=None,
        help=("Name/title of your project surrounded by quotes, words "
              "separated by a space.")
    )

    return parser


def get_names(title):
    """
    Recieves a title string and returns all the possible usages
    of the project name.
    """
    if not title:
        return None
    canvas = title.strip().lower()
    return {
        "project_title": canvas.title(),
        "project_cammel": canvas.title().replace(" ", ""),
        "project_snake": canvas.replace(" ", "_"),
        "project_kebab": canvas.replace(" ", "-")
    }


if __name__ == "__main__":
    # Get parser's arguments
    parser = generate_parser()
    args = parser.parse_args()

    # Parse project titles
    project_titles = get_names(args.project_name)

    # Execute the cookiecutter
    cookiecutter.main.cookiecutter(
        ".",
        no_input=True,
        extra_context=project_titles
    )
