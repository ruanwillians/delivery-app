import React from "react";
import { test, beforeEach, describe } from "vitest";
import { render, screen } from "@testing-library/react";
import LoginPage from "./page";

describe("Hello world", () => {
  beforeEach(() => {
    render(<LoginPage />);
  });

  test("renders hello text", () => {
    const helloElement = screen.getByText(/hello/i);
    expect(helloElement).toBeInTheDocument();
  });
});
