# Tofu PR Commenter

Adds opinionated comments to PR's based on tofu `fmt`, `init`, `plan` and `validate` outputs.

## Summary

This Docker-based GitHub Action is designed to work in tandem with  with the **wrapper enabled**, taking the output from a `fmt`, `init`, `plan` or `validate`, formatting it and adding it to a pull request. Any previous comments from this Action are removed to keep the PR timeline clean.

> The `tofu_wrapper` needs to be set to `true` (which is already the default) for the `hashicorp/setup-tofu` step as it enables the capturing of `stdout`, `stderr` and the `exitcode`.

Support (for now) is [limited to Linux](https://help.github.com/en/actions/creating-actions/about-actions#types-of-actions) as Docker-based GitHub Actions can only be used on Linux runners.

## Usage

This action can only be run after a tofu `fmt`, `init`, `plan` or `validate` has completed, and the output has been captured. tofu rarely writes to `stdout` and `stderr` in the same action, so we concatenate the `commenter_input`:

```yaml
- uses: alexnorell/tofu-pr-commenter@v1
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    commenter_type: fmt/init/plan/validate # Choose one
    commenter_input: ${{ format('{0}{1}', steps.step_id.outputs.stdout, steps.step_id.outputs.stderr) }}
    commenter_exitcode: ${{ steps.step_id.outputs.exitcode }}
```

### Inputs

| Name                 | Requirement | Description                                                       |
| -------------------- | ----------- | ----------------------------------------------------------------- |
| `commenter_type`     | _required_  | The type of comment. Options: [`fmt`, `init`, `plan`, `validate`] |
| `commenter_input`    | _required_  | The comment to post from a previous step output.                  |
| `commenter_exitcode` | _required_  | The exit code from a previous step output.                        |

### Environment Variables

| Name                     | Requirement | Description                                                                                                                                               |
| ------------------------ | ----------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `GITHUB_TOKEN`           | _required_  | Used to execute API calls. The `${{ secrets.GITHUB_TOKEN }}` already has permissions, but if you're using your own token, ensure it has the `repo` scope. |
| `TF_WORKSPACE`           | _optional_  | Default: `default`. This is used to separate multiple comments on a pull request in a matrix run.                                                         |
| `EXPAND_SUMMARY_DETAILS` | _optional_  | Default: `true`. This controls whether the comment output is collapsed or not.                                                                            |
| `HIGHLIGHT_CHANGES`      | _optional_  | Default: `true`. This switches `~` to `!` in `plan` diffs to highlight tofu changes in orange. Set to `false` to disable.                            |

All of these environment variables can be set at `job` or `step` level. For example, you could collapse all outputs but expand on a `plan`:

## Screenshots

### `fmt`

![fmt](images/fmt-output.png)

### `init`

![fmt](images/init-output.png)

### `plan`

![fmt](images/plan-output.png)

### `validate`

![fmt](images/validate-output.png)

## Troubleshooting & Contributing

Feel free to head over to the [Issues](https://github.com/robburger/tofu-pr-commenter/issues) tab to see if the issue you're having has already been reported. If not, [open a new one](https://github.com/robburger/tofu-pr-commenter/issues/new) and be sure to include as much relevant information as possible, including code-samples, and a description of what you expect to be happening.

## License

[MIT](LICENSE)
