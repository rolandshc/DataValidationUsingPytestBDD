@unit @DICOM @ImageValidation
Feature: DICOM Image Validatin
  As a cloud system developer,
  I want to validate the incoming DICOM image ,
  So that the system could proceed with valid image data OR return error message to the user why the images are not valid.

  # This feature file does unit testing for the sake of illustrating Gherkin usage.
  # Criteria is based on https://pydicom.github.io/pydicom/1.1/ref_guide.html
      # Summary of DICOM standard PS3.5-2008 chapter 7:
    # If Implicit VR, data element is:
    #    tag, 4-byte length, value.
    #        The 4-byte length can be FFFFFFFF (undefined length)*
    #
    # If Explicit VR:
    #    if OB, OW, OF, SQ, UN, or UT:
    #       tag, VR, 2-bytes reserved (both zero), 4-byte length, value
    #           For all but UT, the length can be FFFFFFFF (undefined length)*
    #   else: (any other VR)
    #       tag, VR, (2 byte length), value
    # * for undefined length, a Sequence Delimitation Item marks the end
    #        of the Value Field.
    # Note, except for the special_VRs, both impl and expl VR use 8 bytes;
    #    the special VRs follow the 8 bytes with a 4-byte length

  @filetype
  Scenario: Validate a valid DICOM file
    Given the DICOM file is valid
    When the DICOM is read by the file validate function
    Then the function could read the file, store the data as DataSet and retrieve the attribute data.

    # it is sufficient to check if the VR is in valid ASCII range, as it is
    # extremely unlikely that the tag length accidentally has such a
    # representation - this would need the first tag to be longer than 16kB
    # (e.g. it should be > 0x4141 = 16705 bytes) implicit_vr_is_assumed

  @filetype @error
  Scenario: Validate a non-valid DICOM file
    Given the DICOM file is not valid
    When the DICOM is read by the file validation function
    Then Error message logs that the file is not a DICOM file.

  @pixelarray
  Scenario: Validate a valid pixel data of from the DICOM attributes
    Given the DataSet attributes contain 'PixelData', 'FloatPixelData', 'DoubleFloatPixelData'
    When the pixel data validation function reads the pixelarray
    Then the function is able to retrieve the pixel data and meta data.

  @pixelarray @error
  Scenario: Validate a valid pixel data of from the DICOM attributes
    Given the DataSet attributes does not contain 'PixelData'
    When the pixel data validation function reads the pixelarray
    Then Error message logs that the file has no pixeldata and maybe corrupted.

  @pixelarray @error
  Scenario: Validate a valid pixel data of from the DICOM attributes
    Given the DataSet attributes does not contain 'FloatPixelData'
    When the pixel data validation function reads the pixelarray
    Then Error message logs that the file has no pixeldata and maybe corrupted.

  @pixelarray @error
  Scenario: Validate a valid pixel data of from the DICOM attributes
    Given the DataSet attributes does not contain 'DoubleFloatPixelData'
    When the pixel data validation function reads the pixelarray
    Then Error message logs that the file has no pixeldata and maybe corrupted.
