import React, { useState, useEffect } from "react";
import { Autocomplete, AutocompleteProps } from "@mui/material";

export function LazyAutocomplete<T>(
  props: Omit<AutocompleteProps<T, false, false, false>, "options"> & { options: T[] }
) {
  const { options = [], value = null, isOptionEqualToValue, ...rest } = props;
  const [open, setOpen] = useState(false);
  const [inputValue, setInputValue] = useState("");

  const activeOptions = (open || (inputValue && inputValue.trim() !== ""))
    ? options
    : (value ? [value] : []);

  useEffect(() => {
    if (!open || !inputValue || inputValue.trim() === "") return;

    const getOptionLabel = props.getOptionLabel || ((option: any) => String(option));
    const filtered = options.filter((option) => {
      const label = getOptionLabel(option).toLowerCase();
      return label.includes(inputValue.trim().toLowerCase());
    });

    if (filtered.length === 1) {
      const match = filtered[0];
      const isAlreadySelected = value === match || (value && typeof value === "object" && typeof match === "object" && (value as any).id === (match as any).id);
      
      if (!isAlreadySelected) {
        if (props.onChange) {
          props.onChange(null as any, match, "selectOption", undefined as any);
        }
        setOpen(false);
      }
    }
  }, [inputValue, options, open, value, props.onChange, props.getOptionLabel]);

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
      options={activeOptions}
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
      onInputChange={(e, val, reason) => {
        if (reason === "input") {
          setInputValue(val);
        } else if (reason === "reset" || reason === "clear") {
          setInputValue("");
        }
        if (rest.onInputChange) rest.onInputChange(e, val, reason);
      }}
      {...rest}
    />
  );
}
