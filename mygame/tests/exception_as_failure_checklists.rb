Preflight do
  checklist "An exception in checklist counts as failure but must continue with the other checklists" do
    # FIXME: This is currently not testeable, if checklist rescues an exception, the checklist fails
    # a possibility to test it could be capturing the output outside the checklist
    # through the Printer

    # raise "This is an Expected Exception. If you don't see it, you broke something :P"
  end
end
