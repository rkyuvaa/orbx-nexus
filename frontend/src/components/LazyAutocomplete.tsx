import React from "react";
import { Autocomplete, AutocompleteProps } from "@mui/material";

export function LazyAutocomplete<T>(
  props: Omit<AutocompleteProps<T, false, false, false>, "options"> & { options: T[] }
) {
  const { options = [], value = null, isOptionEqualToValue, ...rest } = props;

  return (
    <Autocomplete
      openOnFocus
      isOptionEqualToValue={
        isOptionEqualToValue ||
        ((option: any, val: any) => {
          if (!option || !val) return option === val;
          if (typeof option === "object" && typeof val === "object" && "id" in option && "id" in val) {
            return String(option.id) === String(val.id);
          }
          return option === val;
        })
      }
      options={options}
      value={value}
      {...rest}
    />
  );
}
