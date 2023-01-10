// See: https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html

// Header
#macro gltf_magic   0x46546C67
#macro gltf_version 2

// componentType
#macro gltf_s8  5120
#macro gltf_u8  5121
#macro gltf_s16 5122
#macro gltf_u16 5123
#macro gltf_u32 5124
#macro gltf_f32 5126

// Type
#macro gltf_scalar "SCALAR"
#macro gltf_vec2   "VEC2"
#macro gltf_vec3   "VEC3"
#macro gltf_vec4   "VEC4"
#macro gltf_mat2   "MAT2"
#macro gltf_mat3   "MAT3"
#macro gltf_mat4   "MAT4"

// Vertex attributes
#macro gltf_att_position "POSITION"
#macro gltf_att_normal   "NORMAL"
#macro gltf_att_tangent  "TANGENT"
#macro gltf_att_texcoord "TEXCOORD_"
#macro gltf_att_color    "COLOR_"
// (Not supported with morph targets:)
#macro gltf_att_joints   "JOINTS_"
#macro gltf_att_weights  "WEIGHTS_"

// MIME types
#macro gltf_mime_png "image/png"
#macro gltf_mime_jpg "image/jpeg"

// Animation channel paths
#macro gltf_anim_translation "translation"
#macro gltf_anim_rotation    "rotation"
#macro gltf_anim_scale       "scale"
#macro gltf_anim_weights     "weights"

// Decode/encode real floating-point value from/to a normalized integer
function gltfSignedByteToFloat(_c)    { return max(_c / 127.0, -1.0); }
function gltfFloatToSignedByte(_f)    { return round(_f * 127.0) }
function gltfUnsignedByteToFloat(_c)  { return _c / 255.0; }
function gltfFloatToUnsignedByte(_f)  { return round(_f * 255.0); }
function gltfSignedShortToFloat(_c)   { return max(_c / 32767.0, -1.0); }
function gltfFloatToSignedShort(_f)   { return round(_f * 32767.0); }
function gltfUnsignedShortToFloat(_c) { return _c / 65535.0; }
function gltfFloatToUnsignedShort(_f) { return round(_f * 65535.0); }

function gltfIntegerToFloat(_type, _value) {
	switch (_type) {
		case gltf_s8:
			return gltfSignedByteToFloat(_value);

		case gltf_u8:
			return gltfUnsignedByteToFloat(_value);

		case gltf_s16:
			return gltfSignedShortToFloat(_value);

		case gltf_u16:
			return gltfUnsignedShortToFloat(_value);

		default:
			throw "Invalid integer type " + string(_type) + "!";
	}
}

function gltfFloatToInteger(_type, _value) {
	switch (_type) {
		case gltf_s8:
			return gltfFloatToSignedByte(_value);

		case gltf_u8:
			return gltfFloatToUnsignedByte(_value);

		case gltf_s16:
			return gltfFloatToSignedShort(_value);

		case gltf_u16:
			return gltfFloatToUnsignedShort(_value);

		default:
			throw "Invalid integer type " + string(_type) + "!";
	}
}

// Chunk types
#macro gltf_chunk_json 0x4E4F534A
#macro gltf_chunk_bin  0x004E4942

// Interpolation algorithms
#macro gltf_int_linear      "LINEAR"
#macro gltf_int_step        "STEP"
#macro gltf_int_cubicspline "CUBICSPLINE"

// Buffer types
#macro gltf_buffer_array         34962
#macro gltf_buffer_element_array 34963

// Camera types
#macro gltf_camera_orthographic "orthographic"
#macro gltf_camera_perspective  "perspective"

// Alpha modes
#macro gltf_alpha_opaque "OPAQUE"
#macro gltf_alpha_mask   "MASK"
#macro gltf_alpha_blend  "BLEND"

// Primitive types
#macro gltf_pr_points         0
#macro gltf_pr_lines          1
#macro gltf_pr_line_loop      2
#macro gltf_pr_line_strip     3
#macro gltf_pr_triangles      4
#macro gltf_pr_triangle_strip 5
#macro gltf_pr_triangle_fan   6

// Texture filters
// Min and mag:
#macro gltf_filter_nearest                9728
#macro gltf_filter_linear                 9729
// Min only:
#macro gltf_filter_nearest_mipmap_nearest 9984
#macro gltf_filter_linear_mipmap_nearest  9985
#macro gltf_filter_nearest_mipmap_linear  9986
#macro gltf_filter_linear_mipmap_linear   9987

// Texture wrap
#macro gltf_wrap_clamp_to_edge   33071
#macro gltf_wrap_mirrored_repeat 33648
#macro gltf_wrap_repeat          10497

function __gltfGetObject(_json, _constructor) {
	gml_pragma("forceinline");
	if (_json != undefined) {
		return new _constructor(_json);
	}
	return undefined;
}

function __gltfGetObjectArray(_json, _constructor) {
	gml_pragma("forceinline");
	if (_json != undefined) {
		var _arr = [];
		var i = 0;
		repeat (array_length(_json)) {
			array_push(_arr, __gltfGetObject(_json[i++], _constructor));
		}
		return _arr;
	}
	return undefined;
}

function gltfAccessor(_json={}) constructor {
	/// @var {Real, Undefined}
	bufferView = _json[$ "bufferView"];

	/// @var {Real}
	byteOffset = _json[$ "byteOffset"] ?? 0;

	/// @var {Real}
	componentType = _json[$ "componentType"] ?? -1;

	/// @var {Bool}
	normalized = _json[$ "normalized"] ?? false;

	/// @var {Real}
	count = _json[$ "count"] ?? -1;

	/// @var {String}
	type = _json[$ "type"] ?? "";

	/// @var {Array<Real>}
	max_ = _json[$ "max"];

	/// @var {Array<Real>}
	min_ = _json[$ "min"];

	/// @var {Struct.gltfAccessorSparse, Undefined}
	sparse = __gltfGetObject(_json[$ "sparse"], gltfAccessorSparse);

	/// @var {String}
	name = _json[$ "name"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfAccessorSparse(_json={}) constructor {
	/// @var {Real}
	count = _json[$ "count"] ?? -1;

	/// @var {Struct.gltfAccessorSparseIndices, Undefined}
	indices = __gltfGetObject(_json[$ "indices"], gltfAccessorSparseIndices);

	/// @var {Struct.gltfAccessorSparseValues, Undefined}
	values = __gltfGetObject(_json[$ "values"], gltfAccessorSparseValues);

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfAccessorSparseIndices(_json={}) constructor {
	/// @var {Real}
	bufferView = _json[$ "bufferView"] ?? -1;

	/// @var {Real}
	byteOffset = _json[$ "byteOffset"] ?? 0;

	/// @var {Real}
	compontentType = _json[$ "compontentType"] ?? -1;

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfAccessorSparseValues(_json={}) constructor {
	/// @var {Real}
	bufferView = _json[$ "bufferView"] ?? -1;

	/// @var {Real§}
	byteOffset = _json[$ "byteOffset"] ?? 0;

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfAnimation(_json={}) constructor {
	/// @var {Array<Struct.gltfAnimationChannel>, Undefined}
	channels = __gltfGetObjectArray(_json[$ "channels"] ?? [], gltfAnimationChannel);

	/// @var {Array<Struct.gltfAnimationSampler>, Undefined}
	samplers = __gltfGetObjectArray(_json[$ "samplers"] ?? [], gltfAnimationSampler);

	/// @var {String, Undefined}
	name = _json[$ "name"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfAnimationChannel(_json={}) constructor {
	/// @var {Real}
	sampler = _json[$ "sampler"] ?? -1;

	/// @var {Struct.gltfAnimationChannelTarget, Undefined}
	target = __gltfGetObject(_json[$ "target"], gltfAnimationChannelTarget);

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfAnimationChannelTarget(_json={}) constructor {
	/// @var {Real}
	node = _json[$ "node"] ?? -1;

	/// @var {String}
	path = _json[$ "path"] ?? "";

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfAnimationSampler(_json={}) constructor {
	/// @var {Real}
	input = _json[$ "input"] ?? -1;

	/// @var {String}
	interpolation = _json[$ "interpolation"] ?? gltf_int_linear;

	/// @var {Real}
	output = _json[$ "output"] ?? -1;

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfAsset(_json={}) constructor {
	/// @var {String, Undefined}
	copyright = _json[$ "copyright"];

	/// @var {String, Undefined}
	generator = _json[$ "generator"];

	/// @var {String}
	version = _json[$ "version"] ?? "";

	/// @var {String, Undefined}
	minVersion = _json[$ "minVersion"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfBuffer(_json={}) constructor {
	/// @var {String, Undefined}
	uri = _json[$ "uri"];

	/// @var {Real}
	byteLength = _json[$ "byteLength"] ?? -1;

	/// @var {String, Undefined}
	name = _json[$ "name"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfBufferView(_json={}) constructor {
	/// @var {Real}
	buffer = _json[$ "buffer"] ?? -1;

	/// @var {Real}
	byteOffset = _json[$ "byteOffset"] ?? 0;

	/// @var {Real}
	byteLength = _json[$ "byteLength"] ?? -1;

	/// @var {Real, Undefined}
	byteStride = _json[$ "byteStride"];

	/// @var {Real, Undefined}
	target = _json[$ "target"];

	/// @var {String, Undefined}
	name = _json[$ "name"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfCamera(_json={}) constructor {
	/// @var {Struct.gltfCameraOrthographic, Undefined}
	orthographic = __gltfGetObject(_json[$ "orthographic"], gltfCameraOrthographic);

	/// @var {Struct.gltfCameraPerspective, Undefined}
	perspective = __gltfGetObject(_json[$ "perspective"], gltfCameraPerspective);

	/// @var {String}
	type = _json[$ "type"] ?? "";

	/// @var {Struct, Undefined}
	name = _json[$ "name"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfCameraOrthographic(_json={}) constructor {
	/// @var {Real}
	xmag = _json[$ "xmag"] ?? -1;

	/// @var {Real}
	ymag = _json[$ "ymag"] ?? -1;

	/// @var {Real}
	zfar = _json[$ "zfar"] ?? -1;

	/// @var {Real}
	znear = _json[$ "znear"] ?? -1;

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfCameraPerspective(_json={}) constructor {
	/// @var {Real, Undefined}
	aspectRatio = _json[$ "aspectRatio"];

	/// @var {Real}
	yfov = _json[$ "yfov"] ?? -1;

	/// @var {Real}
	zfar = _json[$ "zfar"];

	/// @var {Real}
	znear = _json[$ "znear"] ?? -1;

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltf(_json={}) constructor {
	/// @var {String, Undefined}
	extensionsUsed = _json[$ "extensionsUsed"];

	/// @var {String, Undefined}
	extensionsRequired = _json[$ "extensionsRequired"];

	/// @var {Array<Struct.gltfAccessor>, Undefined}
	accessors = __gltfGetObjectArray(_json[$ "accessors"], gltfAccessor);

	/// @var {Array<Struct.gltfAnimation>, Undefined}
	animations = __gltfGetObjectArray(_json[$ "animations"], gltfAnimation);

	/// @var {Struct.gltfAsset}
	asset = __gltfGetObject(_json[$ "asset"], gltfAsset);

	/// @var {Array<Struct.gltfBuffer>, Undefined}
	buffers = __gltfGetObjectArray(_json[$ "buffers"], gltfBuffer);

	/// @var {Array<Struct.gltfBufferView>, Undefined}
	bufferViews =__gltfGetObjectArray(_json[$ "bufferViews"], gltfBufferView);

	/// @var {Array<Struct.gltfCamera>, Undefined}
	cameras = __gltfGetObjectArray(_json[$ "cameras"], gltfCamera);

	/// @var {Array<Struct.gltfImage>, Undefined}
	images = __gltfGetObjectArray(_json[$ "images"], gltfImage);

	/// @var {Array<Struct.gltfMaterial>, Undefined}
	materials = __gltfGetObjectArray(_json[$ "materials"], gltfMaterial);

	/// @var {Array<Struct.gltfMesh>, Undefined}
	meshes = __gltfGetObjectArray(_json[$ "meshes"], gltfMesh);

	/// @var {Array<Struct.gltfNode>, Undefined}
	nodes = __gltfGetObjectArray(_json[$ "nodes"], gltfNode);

	/// @var {Array<Struct.gltfSampler>, Undefined}
	samplers = __gltfGetObjectArray(_json[$ "samplers"], gltfSampler);

	/// @var {Real, Undefined}
	scene = _json[$ "scene"];

	/// @var {Array<Struct.gltfSkin>, Undefined}
	skins = __gltfGetObjectArray(_json[$ "skins"], gltfSkin);

	/// @var {Array<Struct.gltfTexture>, Undefined}
	textures = __gltfGetObjectArray(_json[$ "textures"], gltfTexture);

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfImage(_json={}) constructor {
	/// @var {String, Undefined}
	uri = _json[$ "uri"];

	/// @var {String, Undefined}
	mimeType = _json[$ "mimeType"];

	/// @var {Real, Undefined}
	bufferView = _json[$ "bufferView"];

	/// @var {String, Undefined}
	name = _json[$ "name"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfMaterial(_json={}) constructor {
	/// @var {String, Undefined}
	name = _json[$ "name"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];

	/// @var {Struct.gltfMaterialPBRMetallicRoughness, Undefined}
	pbrMetallicRoughness = __gltfGetObject(_json[$ "pbrMetallicRoughness"], gltfMaterialPBRMetallicRoughness);

	/// @var {Struct.gltfMaterialNormalTextureInfo, Undefined}
	normalTexture = __gltfGetObject(_json[$ "normalTexture"], gltfMaterialNormalTextureInfo);

	/// @var {Struct.gltfMaterialNormalTextureInfo, Undefined}
	occlusionTexture = __gltfGetObject(_json[$ "occlusionTexture"], gltfMaterialOcclusionTextureInfo);

	/// @var {Struct.gltfTextureInfo, Undefined}
	emissiveTexture = __gltfGetObject(_json[$ "emissiveTexture"], gltfTextureInfo);

	/// @var {Array<Real>}
	emissiveFactor = _json[$ "emissiveFactor"] ?? [0, 0, 0];

	/// @var {String}
	alphaMode = _json[$ "alphaMode"] ?? gltf_alpha_opaque;

	/// @var {Real}
	alphaCutoff = _json[$ "alphaCutoff"] ?? 0.5;

	/// @var {Bool}
	doubleSided = _json[$ "doubleSided"] ?? false;
}

function gltfMaterialNormalTextureInfo(_json={}) constructor {
	/// @var {Real}
	index = _json[$ "index"] ?? -1;

	/// @var {Real}
	texCoord = _json[$ "texCoord"] ?? 0;

	/// @var {Real}
	scale = _json[$ "scale"] ?? 1;

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfMaterialOcclusionTextureInfo(_json={}) constructor {
	/// @var {Real}
	index = _json[$ "index"] ?? -1;

	/// @var {Real}
	texCoord = _json[$ "texCoord"] ?? 0;

	/// @var {Real}
	strength = _json[$ "strength"] ?? 1;

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfMaterialPBRMetallicRoughness(_json={}) constructor {
	/// @var {Array<Real>}
	baseColorFactor = _json[$ "baseColorFactor"] ?? [1, 1, 1, 1];

	/// @var {Struct.gltfTextureInfo, Undefined}
	baseColorTexture = __gltfGetObject(_json[$ "baseColorTexture"], gltfTextureInfo);

	/// @var {Real}
	metallicFactor = _json[$ "metallicFactor"] ?? 1;

	/// @var {Real}
	roughnessFactor = _json[$ "roughnessFactor"] ?? 1;

	/// @var {Struct.gltfTextureInfo, Undefined}
	metallicRoughnessTexture = __gltfGetObject(_json[$ "metallicRoughnessTexture"], gltfTextureInfo);

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfMesh(_json={}) constructor {
	/// @var {Array<Struct.gltfMeshPrimitive>}
	primitives = __gltfGetObjectArray(_json[$ "primitives"] ?? [], gltfMeshPrimitive);

	/// @var {Array<Real>, Undefined}
	weights = _json[$ "weights"];

	/// @var {String, Undefined}
	name = _json[$ "name"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfMeshPrimitive(_json={}) constructor {
	/// @var {Struct}
	attributes = _json[$ "attributes"] ?? {};

	/// @var {Real, Undefined}
	indices = _json[$ "indices"];

	/// @var {Real, Undefined}
	material = _json[$ "material"];

	/// @var {Real}
	mode = _json[$ "mode"] ?? gltf_pr_triangles;

	/// @var {Array<Struct>, Undefined}
	targets = _json[$ "targets"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfNode(_json={}) constructor {
	/// @var {Real, Undefined}
	camera = _json[$ "camera"];

	/// @var {Array<Real>, Undefined}
	children = _json[$ "children"];

	/// @var {Real, Undefined}
	skin = _json[$ "skin"];

	/// @var {Array<Matrix>}
	matrix = _json[$ "matrix"] ?? matrix_build_identity();

	/// @var {Real, Undefined}
	mesh = _json[$ "mesh"];

	/// @var {Array<Real>}
	rotation = _json[$ "rotation"] ?? [0, 0, 0, 1];

	/// @var {Array<Real>}
	scale = _json[$ "scale"] ?? [1, 1, 1];

	/// @var {Array<Real>}
	translation = _json[$ "translation"] ?? [0, 0, 0];

	/// @var {Array<Real>, Undefined}
	weights = _json[$ "weights"];

	/// @var {String, Undefined}
	name = _json[$ "name"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfSampler(_json={}) constructor {
	/// @var {Real, Undefined}
	magFilter = _json[$ "magFilter"];

	/// @var {Real, Undefined}
	minFilter = _json[$ "minFilter"];

	/// @var {Real}
	wrapS = _json[$ "wrapS"] ?? gltf_wrap_repeat;

	/// @var {Real}
	wrapT = _json[$ "wrapT"] ?? gltf_wrap_repeat;

	/// @var {Real, Undefined}
	name = _json[$ "name"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfScene(_json={}) constructor {
	/// @var {Array<Real>, Undefined}
	nodes = _json[$ "nodes"];

	/// @var {String, Undefined}
	name = _json[$ "name"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfSkin(_json={}) constructor {
	/// @var {Real, Undefined}
	inverseBindMatrices = _json[$ "inverseBindMatrices"];

	/// @var {Real}
	skeleton = _json[$ "skeleton"];

	/// @var {Array<Real>}
	joints = _json[$ "joints"] ?? [];

	/// @var {String, Undefined}
	name = _json[$ "name"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfTexture(_json={}) constructor {
	/// @var {Real, Undefined}
	sampler = _json[$ "sampler"];

	/// @var {Real, Undefined}
	source = _json[$ "source"];

	/// @var {String, Undefined}
	name = _json[$ "name"];

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

function gltfTextureInfo(_json={}) constructor {
	/// @var {Real}
	index = _json[$ "index"] ?? -1;

	/// @var {Real}
	texCoord = _json[$ "texCoord"] ?? 0;

	/// @var {Struct, Undefined}
	extensions = _json[$ "extensions"];

	/// @var {Any}
	extras = _json[$ "extras"];
}

/// @func gltfLoad(_path)
///
/// @param {String} _path
///
/// @return {Struct.gltf, Undefined}
function gltfLoad(_path) {
	var _file = file_text_open_read(_path);
	if (_file != -1) {
		var _string = "";
		while (!file_text_eof(_file)) {
			_string += file_text_read_string(_file) + "\n";
			file_text_readln(_file);
		}
		file_text_close(_file);
		var _json = json_parse(_string);
		return new gltf(_json);
	}
	return undefined;
}
