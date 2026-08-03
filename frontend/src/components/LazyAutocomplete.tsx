import React, { useState } from "react";
import { Autocomplete, AutocompleteProps } from "@mui/material";

export function LazyAutocomplete<T>(
  props: Omit<AutocompleteProps<T, false, false, false>, "options"> & { options: T[] }
) {
  const { options, value, ...rest } = props;
  const [open, setOpen] = useState(false);

  const activeOptions = open
    ? options
    : (value ? [value] : []);

  return (
    <Autocomplete
      {...rest}
      value={value}
      open={open}
      onOpen={(e) => {
        setOpen(true);
        if (rest.onOpen) rest.onOpen(e);
      }}
      onClose={(e, reason) => {
        setOpen(false);
        if (rest.onClose) rest.onClose(e, reason);
      }}
      options={activeOptions}
    />
  );
}
