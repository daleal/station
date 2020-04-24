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
        default="Station",
        help="Name/title of your project using snake_case."
    )

    return parser


def get_names(title):
    """
    Recieves a title string and returns all the possible usages
    of the project name.
    """
    canvas = title.strip().replace("_", " ").lower()
    return {
        "title": canvas.title(),
        "cammel": canvas.title().replace(" ", ""),
        "snake": canvas.replace(" ", "_"),
        "kebab": canvas.replace(" ", "-")
    }


if __name__ == "__main__":
    parser = generate_parser()
    args = parser.parse_args()
    project_titles = get_names(args.project_name)

    # Execute the cookiecutter
    cookiecutter.main.cookiecutter(
        project_titles["kebab"],
        no_input=True,
        extra_context=project_titles
    )
